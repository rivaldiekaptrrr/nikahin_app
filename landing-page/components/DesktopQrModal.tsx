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
        className="relative w-full max-w-sm bg-white rounded-3xl p-6 sm:p-7 shadow-2xl border border-slate-100 text-center"
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
        <div className="w-12 h-12 rounded-2xl bg-[#fdf0de] mx-auto flex items-center justify-center text-[#d81b60] mb-4">
          <QrCode className="w-6 h-6" />
        </div>

        <h3 className="font-extrabold text-lg text-slate-900 mb-1">
          Buka di Ponselmu
        </h3>
        <p className="text-xs text-slate-500 font-medium mb-6">
          Arahkan kamera ponsel ke kode QR untuk membuka aplikasi langsung di HP kamu.
        </p>

        {/* QR Code Frame */}
        <div className="p-4 bg-white rounded-2xl border-2 border-dashed border-[#ffd9e2] inline-block shadow-inner mb-5">
          <QRCodeSVG
            value={targetUrl}
            size={180}
            level="M"
            includeMargin={true}
            fgColor="#0f172a"
          />
        </div>

        {/* Device Notes */}
        <div className="flex items-center justify-center gap-4 text-xs font-semibold text-slate-600">
          <span className="flex items-center gap-1.5">
            <Smartphone className="w-4 h-4 text-[#d81b60]" />
            Tersedia untuk Android & iPhone
          </span>
        </div>
      </div>
    </div>
  );
}

