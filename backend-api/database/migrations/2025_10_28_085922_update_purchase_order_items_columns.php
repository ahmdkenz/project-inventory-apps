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
        Schema::table('purchase_order_items', function (Blueprint $table) {
            // Rename columns to match controller expectations
            $table->renameColumn('jumlah', 'qty');
            $table->renameColumn('harga', 'harga_satuan');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('purchase_order_items', function (Blueprint $table) {
            // Revert column renames
            $table->renameColumn('qty', 'jumlah');
            $table->renameColumn('harga_satuan', 'harga');
        });
    }
};
