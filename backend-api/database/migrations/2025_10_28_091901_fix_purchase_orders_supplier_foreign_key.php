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
        Schema::table('purchase_orders', function (Blueprint $table) {
            // Drop the old foreign key constraint pointing to 'supplier'
            $table->dropForeign(['supplier_id']);
            
            // Add new foreign key constraint pointing to 'suppliers'
            $table->foreign('supplier_id')->references('id')->on('suppliers')->onDelete('cascade');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('purchase_orders', function (Blueprint $table) {
            // Drop the foreign key constraint
            $table->dropForeign(['supplier_id']);
            
            // Restore the old foreign key constraint pointing to 'supplier'
            $table->foreign('supplier_id')->references('id')->on('supplier')->onDelete('cascade');
        });
    }
};
