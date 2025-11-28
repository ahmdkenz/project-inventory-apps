    /**
 * Utility functions for PPN (Pajak Pertambahan Nilai) calculations
 * Centralized PPN rate management for consistent calculations across the application
 */

// PPN rate untuk Purchase Order dan dokumen terkait (2%)
export const PPN_RATE = 0.02;

// Test function untuk memastikan perhitungan benar
export function testPpnCalculation() {
  const testSubtotal = 1000000; // 1 juta
  const expectedPpn = 20000; // 2% dari 1 juta = 20 ribu
  const calculatedPpn = computePpn(testSubtotal);
  
  console.log('PPN Test:', {
    subtotal: testSubtotal,
    expected: expectedPpn,
    calculated: calculatedPpn,
    match: calculatedPpn === expectedPpn
  });
  
  return calculatedPpn === expectedPpn;
}

/**
 * Menghitung nilai PPN berdasarkan subtotal
 * @param subtotal Nilai subtotal sebelum PPN
 * @returns Nilai PPN yang sudah dibulatkan
 */
export function computePpn(subtotal: number): number {
  if (!subtotal || subtotal <= 0) {
    console.log('computePpn: subtotal is 0 or invalid:', subtotal);
    return 0;
  }
  const result = Math.round(subtotal * PPN_RATE);
  console.log(`computePpn: subtotal=${subtotal}, rate=${PPN_RATE}, result=${result}`);
  return result;
}

/**
 * Menghitung persentase PPN berdasarkan nilai PPN dan subtotal
 * @param ppn Nilai PPN (dari server atau null)
 * @param subtotal Nilai subtotal
 * @returns Persentase PPN (dalam bentuk integer, misal: 2 untuk 2%)
 */
export function computePpnPercent(ppn: number | null | undefined, subtotal: number | null | undefined): number {
  // Selalu return 2% karena aplikasi menggunakan PPN 2% tetap
  console.log('computePpnPercent called with:', { ppn, subtotal });
  return Math.round(PPN_RATE * 100); // Always return 2
}

/**
 * Menghitung total akhir (subtotal + PPN)
 * @param subtotal Nilai subtotal
 * @param ppn Nilai PPN (opsional, akan dihitung jika tidak ada)
 * @returns Total akhir
 */
export function computeGrandTotal(subtotal: number, ppn?: number | null): number {
  const s = subtotal || 0;
  const p = ppn ?? computePpn(s);
  return s + p;
}

/**
 * Memformat nilai mata uang dalam format IDR
 * @param value Nilai yang akan diformat
 * @returns String format mata uang IDR
 */
export function formatCurrency(value: number): string {
  return new Intl.NumberFormat('id-ID', {
    style: 'currency',
    currency: 'IDR',
    minimumFractionDigits: 0
  }).format(value || 0);
}