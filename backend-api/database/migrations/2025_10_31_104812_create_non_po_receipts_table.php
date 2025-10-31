<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('non_po_receipts', function (Blueprint $table) {
            $table->id();
            $table->string('no_dokumen')->unique(); // GR-NON-XXXXX
            $table->string('source'); // Sumber barang (Retur, Hibah, dll)
            $table->date('receive_date'); // Tanggal diterima
            $table->text('notes'); // Catatan
            $table->decimal('total_value', 15, 2)->default(0); // Total nilai (opsional)
            $table->foreignId('created_by')->constrained('users'); // User yang mencatat
            $table->timestamps();
            $table->softDeletes();
        });

        // Detail items untuk non-PO receipt
        Schema::create('non_po_receipt_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('non_po_receipt_id')->constrained()->onDelete('cascade');
            $table->foreignId('barang_id')->constrained('barang');
            $table->integer('qty'); // Jumlah diterima
            $table->decimal('price', 15, 2)->default(0); // Harga satuan (opsional)
            $table->decimal('subtotal', 15, 2)->default(0); // Subtotal
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('non_po_receipt_items');
        Schema::dropIfExists('non_po_receipts');
    }
};
