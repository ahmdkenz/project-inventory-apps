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
        Schema::create('non_po_issues', function (Blueprint $table) {
            $table->id();
            $table->string('no_dokumen')->unique(); // OUT-NON-XXXXX
            $table->string('recipient'); // Penerima/Tujuan
            $table->date('issue_date'); // Tanggal dikeluarkan
            $table->text('notes')->nullable(); // Catatan pengeluaran
            $table->foreignId('created_by')->constrained('users'); // User yang mencatat
            $table->timestamps();
            $table->softDeletes();
        });

        // Detail items untuk non-PO issue
        Schema::create('non_po_issue_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('non_po_issue_id')->constrained()->onDelete('cascade');
            $table->foreignId('barang_id')->constrained('barang');
            $table->integer('qty'); // Jumlah dikeluarkan
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('non_po_issue_items');
        Schema::dropIfExists('non_po_issues');
    }
};
