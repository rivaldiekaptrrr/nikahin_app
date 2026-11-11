const fs = require('fs');
const zlib = require('zlib');
const path = require('path');

function paethPredictor(a, b, c) {
  const p = a + b - c;
  const pa = Math.abs(p - a);
  const pb = Math.abs(p - b);
  const pc = Math.abs(p - c);
  if (pa <= pb && pa <= pc) return a;
  if (pb <= pc) return b;
  return c;
}

function unfilterPNG(raw, width, height, bpp) {
  const stride = width * bpp;
  const out = Buffer.alloc(stride * height);
  for (let y = 0; y < height; y++) {
    const filter = raw[y * (1 + stride)];
    const rawStart = y * (1 + stride) + 1;
    const outStart = y * stride;
    const prevStart = (y - 1) * stride;

    for (let x = 0; x < stride; x++) {
      const byte = raw[rawStart + x];
      const left = x >= bpp ? out[outStart + x - bpp] : 0;
      const up = y > 0 ? out[prevStart + x] : 0;
      const upLeft = (y > 0 && x >= bpp) ? out[prevStart + x - bpp] : 0;

      let val = 0;
      if (filter === 0) val = byte;
      else if (filter === 1) val = (byte + left) & 0xff;
      else if (filter === 2) val = (byte + up) & 0xff;
      else if (filter === 3) val = (byte + Math.floor((left + up) / 2)) & 0xff;
      else if (filter === 4) val = (byte + paethPredictor(left, up, upLeft)) & 0xff;
      out[outStart + x] = val;
    }
  }
  return out;
}

function crc32(buf) {
  let table = [];
  for (let n = 0; n < 256; n++) {
    let c = n;
    for (let k = 0; k < 8; k++) {
      if (c & 1) c = 0xedb88320 ^ (c >>> 1);
      else c = c >>> 1;
    }
    table[n] = c;
  }
  let c = 0xffffffff;
  for (let i = 0; i < buf.length; i++) {
    c = table[(c ^ buf[i]) & 0xff] ^ (c >>> 8);
  }
  return (c ^ 0xffffffff) >>> 0;
}

function makeChunk(type, data) {
  const len = data.length;
  const chunk = Buffer.alloc(12 + len);
  chunk.writeUInt32BE(len, 0);
  chunk.write(type, 4, 4, 'ascii');
  data.copy(chunk, 8);
  const typeAndData = chunk.slice(4, 8 + len);
  const crc = crc32(typeAndData);
  chunk.writeUInt32BE(crc, 8 + len);
  return chunk;
}

function encodeRGBAtoPNG(rgbaBuf, width, height) {
  const sig = Buffer.from([0x89, 0x50, 0x4e, 0x47, 0x0d, 0x0a, 0x1a, 0x0a]);
  const ihdrData = Buffer.alloc(13);
  ihdrData.writeUInt32BE(width, 0);
  ihdrData.writeUInt32BE(height, 4);
  ihdrData[8] = 8;
  ihdrData[9] = 6;
  ihdrData[10] = 0;
  ihdrData[11] = 0;
  ihdrData[12] = 0;
  const ihdr = makeChunk('IHDR', ihdrData);

  const raw = Buffer.alloc((1 + width * 4) * height);
  for (let y = 0; y < height; y++) {
    const rawPos = y * (1 + width * 4);
    raw[rawPos] = 0;
    rgbaBuf.copy(raw, rawPos + 1, y * width * 4, (y + 1) * width * 4);
  }
  const idat = makeChunk('IDAT', zlib.deflateSync(raw, { level: 9 }));
  const iend = makeChunk('IEND', Buffer.alloc(0));
  return Buffer.concat([sig, ihdr, idat, iend]);
}

const rootDir = path.resolve(__dirname, '..');
const symbolPath = path.join(rootDir, '..', 'assets', 'logo', 'png', 'nikahin-symbol-master-512.png');

console.log('Reading master symbol from:', symbolPath);
const symbolFile = fs.readFileSync(symbolPath);
let pos = 8;
const idatChunks = [];
while (pos < symbolFile.length) {
  const len = symbolFile.readUInt32BE(pos);
  const type = symbolFile.slice(pos + 4, pos + 8).toString('ascii');
  if (type === 'IDAT') idatChunks.push(symbolFile.slice(pos + 8, pos + 8 + len));
  pos += 12 + len;
}
const raw = zlib.inflateSync(Buffer.concat(idatChunks));
const symbolRGBA = unfilterPNG(raw, 512, 512, 4);

// Create 512x512 Master Circular RGBA Canvas
const masterWidth = 512;
const masterHeight = 512;
const canvas = Buffer.alloc(masterWidth * masterHeight * 4);

const cx = 255.5;
const cy = 255.5;
const radius = 256.0;

// Gradient: #FDF0DE (253, 240, 222) to #F6DEBA (246, 222, 186)
// Rim stroke: #E4C69F (228, 198, 159)
for (let y = 0; y < masterHeight; y++) {
  for (let x = 0; x < masterWidth; x++) {
    const dx = x - cx;
    const dy = y - cy;
    const dist = Math.sqrt(dx * dx + dy * dy);
    const idx = (y * masterWidth + x) * 4;

    if (dist > radius) {
      // 100% transparent outside circle
      canvas[idx] = 0;
      canvas[idx + 1] = 0;
      canvas[idx + 2] = 0;
      canvas[idx + 3] = 0;
    } else {
      let maskAlpha = 1.0;
      if (dist >= radius - 1.5) {
        maskAlpha = (radius - dist) / 1.5;
      }

      // t along top-left to bottom-right diagonal
      const t = Math.max(0, Math.min(1, (x + y) / (masterWidth + masterHeight)));
      let r = Math.round(253 * (1 - t) + 246 * t);
      let g = Math.round(240 * (1 - t) + 222 * t);
      let b = Math.round(222 * (1 - t) + 186 * t);

      // subtle inner rim
      if (dist >= radius - 3.5 && dist < radius - 1.5) {
        const rimBlend = 0.35;
        r = Math.round(r * (1 - rimBlend) + 228 * rimBlend);
        g = Math.round(g * (1 - rimBlend) + 198 * rimBlend);
        b = Math.round(b * (1 - rimBlend) + 159 * rimBlend);
      }

      canvas[idx] = r;
      canvas[idx + 1] = g;
      canvas[idx + 2] = b;
      canvas[idx + 3] = Math.round(255 * maskAlpha);
    }
  }
}

// Composite symbol scaled at 420x420, centered at (46, 46)
const symSize = 420;
const symOffset = 46;
for (let sy = 0; sy < symSize; sy++) {
  for (let sx = 0; sx < symSize; sx++) {
    const origX = Math.floor((sx / symSize) * 512);
    const origY = Math.floor((sy / symSize) * 512);
    const origIdx = (origY * 512 + origX) * 4;

    const sR = symbolRGBA[origIdx];
    const sG = symbolRGBA[origIdx + 1];
    const sB = symbolRGBA[origIdx + 2];
    const sA = symbolRGBA[origIdx + 3] / 255;

    if (sA > 0) {
      const destX = symOffset + sx;
      const destY = symOffset + sy;
      const destIdx = (destY * masterWidth + destX) * 4;

      const dR = canvas[destIdx];
      const dG = canvas[destIdx + 1];
      const dB = canvas[destIdx + 2];
      const dA = canvas[destIdx + 3] / 255;

      const outA = sA + dA * (1 - sA);
      if (outA > 0) {
        canvas[destIdx] = Math.round((sR * sA + dR * dA * (1 - sA)) / outA);
        canvas[destIdx + 1] = Math.round((sG * sA + dG * dA * (1 - sA)) / outA);
        canvas[destIdx + 2] = Math.round((sB * sA + dB * dA * (1 - sA)) / outA);
        canvas[destIdx + 3] = Math.round(outA * 255);
      }
    }
  }
}

// Area-averaging downsampler
function downsample(srcBuf, srcW, srcH, targetW, targetH) {
  const outBuf = Buffer.alloc(targetW * targetH * 4);
  const scaleX = srcW / targetW;
  const scaleY = srcH / targetH;

  for (let ty = 0; ty < targetH; ty++) {
    for (let tx = 0; tx < targetW; tx++) {
      const startX = tx * scaleX;
      const endX = (tx + 1) * scaleX;
      const startY = ty * scaleY;
      const endY = (ty + 1) * scaleY;

      let accR = 0, accG = 0, accB = 0, accA = 0, totalWeight = 0;

      const x0 = Math.floor(startX);
      const x1 = Math.min(srcW - 1, Math.floor(endX));
      const y0 = Math.floor(startY);
      const y1 = Math.min(srcH - 1, Math.floor(endY));

      for (let sy = y0; sy <= y1; sy++) {
        const wy = Math.min(sy + 1, endY) - Math.max(sy, startY);
        for (let sx = x0; sx <= x1; sx++) {
          const wx = Math.min(sx + 1, endX) - Math.max(sx, startX);
          const w = wx * wy;
          const idx = (sy * srcW + sx) * 4;
          const a = srcBuf[idx + 3] / 255;

          accR += srcBuf[idx] * a * w;
          accG += srcBuf[idx + 1] * a * w;
          accB += srcBuf[idx + 2] * a * w;
          accA += a * w;
          totalWeight += w;
        }
      }

      const outIdx = (ty * targetW + tx) * 4;
      if (accA > 0 && totalWeight > 0) {
        outBuf[outIdx] = Math.round(accR / accA);
        outBuf[outIdx + 1] = Math.round(accG / accA);
        outBuf[outIdx + 2] = Math.round(accB / accA);
        outBuf[outIdx + 3] = Math.round((accA / totalWeight) * 255);
      } else {
        outBuf[outIdx] = 0;
        outBuf[outIdx + 1] = 0;
        outBuf[outIdx + 2] = 0;
        outBuf[outIdx + 3] = 0;
      }
    }
  }
  return outBuf;
}

// Generate targets
const png180 = encodeRGBAtoPNG(downsample(canvas, 512, 512, 180, 180), 180, 180);
const png48 = encodeRGBAtoPNG(downsample(canvas, 512, 512, 48, 48), 48, 48);
const png32 = encodeRGBAtoPNG(downsample(canvas, 512, 512, 32, 32), 32, 32);
const png16 = encodeRGBAtoPNG(downsample(canvas, 512, 512, 16, 16), 16, 16);

// Multi-size ICO (16x16 and 32x32)
function makeICO(images) {
  const count = images.length;
  const header = Buffer.alloc(6);
  header.writeUInt16LE(0, 0); // reserved
  header.writeUInt16LE(1, 2); // icon type
  header.writeUInt16LE(count, 4);

  const dirEntries = [];
  let dataOffset = 6 + count * 16;
  const dataBlobs = [];

  for (const img of images) {
    const entry = Buffer.alloc(16);
    entry[0] = img.width === 256 ? 0 : img.width;
    entry[1] = img.height === 256 ? 0 : img.height;
    entry[2] = 0;
    entry[3] = 0;
    entry.writeUInt16LE(1, 4); // color planes
    entry.writeUInt16LE(32, 6); // bpp
    entry.writeUInt32LE(img.buffer.length, 8); // size
    entry.writeUInt32LE(dataOffset, 12); // offset
    dirEntries.push(entry);
    dataBlobs.push(img.buffer);
    dataOffset += img.buffer.length;
  }

  return Buffer.concat([header, ...dirEntries, ...dataBlobs]);
}

const icoBuf = makeICO([
  { width: 16, height: 16, buffer: png16 },
  { width: 32, height: 32, buffer: png32 }
]);

// Write output files
fs.writeFileSync(path.join(rootDir, 'app', 'icon.png'), png48);
fs.writeFileSync(path.join(rootDir, 'public', 'favicon-32x32.png'), png32);
fs.writeFileSync(path.join(rootDir, 'public', 'favicon-16x16.png'), png16);
fs.writeFileSync(path.join(rootDir, 'public', 'favicon.ico'), icoBuf);
fs.writeFileSync(path.join(rootDir, 'public', 'assets', 'apple-touch-icon.png'), png180);

// Also generate circular SVG
const symbolBase64 = symbolFile.toString('base64');
const circularSVG = `<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512" width="512" height="512">
  <defs>
    <clipPath id="circleClip">
      <circle cx="256" cy="256" r="256" />
    </clipPath>
    <linearGradient id="champagnePlate" x1="0%" y1="0%" x2="100%" y2="100%">
      <stop offset="0%" stop-color="#FDF0DE" />
      <stop offset="100%" stop-color="#F6DEBA" />
    </linearGradient>
  </defs>
  <!-- Circular Plate with transparent outside -->
  <circle cx="256" cy="256" r="256" fill="url(#champagnePlate)" />
  <circle cx="256" cy="256" r="254" fill="none" stroke="#E4C69F" stroke-width="3" opacity="0.7" />
  <g clip-path="url(#circleClip)">
    <image x="46" y="46" width="420" height="420" href="data:image/png;base64,${symbolBase64}" />
  </g>
</svg>
`;

fs.writeFileSync(path.join(rootDir, 'app', 'icon.svg'), circularSVG);
fs.writeFileSync(path.join(rootDir, 'public', 'favicon.svg'), circularSVG);

console.log('Successfully generated all circular favicon assets:');
console.log(' - landing-page/app/icon.svg (Vector circular favicon for modern browsers)');
console.log(' - landing-page/public/favicon.svg (Public vector circular favicon)');
console.log(' - landing-page/app/icon.png (48x48 RGBA circular icon)');
console.log(' - landing-page/public/favicon-32x32.png (32x32 RGBA circular icon)');
console.log(' - landing-page/public/favicon-16x16.png (16x16 RGBA circular icon)');
console.log(' - landing-page/public/favicon.ico (Multi-size 16/32 circular ICO)');
console.log(' - landing-page/public/assets/apple-touch-icon.png (180x180 RGBA circular icon)');

