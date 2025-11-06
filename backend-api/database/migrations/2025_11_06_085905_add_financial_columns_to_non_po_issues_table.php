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
        // Add financial columns to non_po_issues table
        Schema::table('non_po_issues', function (Blueprint $table) {
            $table->decimal('subtotal', 15, 2)->default(0)->after('notes'); // Subtotal sebelum PPN
            $table->decimal('ppn', 15, 2)->default(0)->after('subtotal'); // Nilai PPN
            $table->decimal('total', 15, 2)->default(0)->after('ppn'); // Total setelah PPN
        });

        // Add financial columns to non_po_issue_items table
        Schema::table('non_po_issue_items', function (Blueprint $table) {
            $table->decimal('harga_satuan', 15, 2)->default(0)->after('qty'); // Harga satuan (harga_beli)
            $table->decimal('subtotal', 15, 2)->default(0)->after('harga_satuan'); // Subtotal (qty * harga_satuan)
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('non_po_issues', function (Blueprint $table) {
            $table->dropColumn(['subtotal', 'ppn', 'total']);
        });

        Schema::table('non_po_issue_items', function (Blueprint $table) {
            $table->dropColumn(['harga_satuan', 'subtotal']);
        });
    }
};
