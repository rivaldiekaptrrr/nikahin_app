'use client';

import React from 'react';
import { X, QrCode, Smartphone } from 'lucide-react';
import { QRCodeSVG } from 'qrcode.react';

interface DesktopQrModalProps {
  isOpen: boolean;
  onClose: () => void;
  targetUrl: string;
}

export default function DesktopQrModal({ isOpen, onClose, targetUrl }: DesktopQrModalProps) {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm animate-in fade-in duration-200">
      <div
        className="relative w-full max-w-sm bg-white rounded-3xl p-6 sm:p-7 shadow-2xl border border-slate-100"
        onClick={(e) => e.stopPropagation()}
      >
        {/* Close Button */}
        <button
          onClick={onClose}
          className="absolute top-5 right-5 p-2 text-slate-400 hover:text-slate-700 rounded-full hover:bg-slate-100 transition-colors"
          aria-label="Tutup modal"
        >
          <X className="w-5 h-5" />
        </button>

        {/* Modal Header */}
        <div className="flex items-center gap-3.5 mb-5 pr-8">
          <div className="w-11 h-11 rounded-2xl bg-[#fdf0de] flex items-center justify-center text-[#d81b60] shrink-0">
            <QrCode className="w-6 h-6" />
          </div>
          <div>
            <h3 className="font-extrabold text-lg text-slate-900 leading-snug">
              Buka di Ponselmu
            </h3>
            <p className="text-xs text-slate-500 font-medium mt-0.5 text-justify">
              Arahkan kamera ponsel ke kode QR untuk membuka aplikasi langsung di HP kamu.
            </p>
          </div>
        </div>

        {/* QR Code Frame */}
        <div className="flex justify-center mb-5">
          <div className="p-4 bg-white rounded-2xl border-2 border-dashed border-[#ffd9e2] shadow-inner">
            <QRCodeSVG
              value={targetUrl}
              size={180}
              level="M"
              includeMargin={true}
              fgColor="#0f172a"
            />
          </div>
        </div>

        {/* Device Notes */}
        <div className="flex items-center justify-center gap-2 text-xs font-semibold text-slate-600">
          <Smartphone className="w-4 h-4 text-[#d81b60]" />
          <span>Tersedia untuk Android & iPhone</span>
        </div>
      </div>
    </div>
  );
}

