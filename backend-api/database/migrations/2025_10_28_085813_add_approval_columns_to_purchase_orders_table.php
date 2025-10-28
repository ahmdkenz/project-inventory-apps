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
            // Rename existing columns to match controller expectations
            $table->renameColumn('nomor', 'no_po');
            $table->renameColumn('user_id', 'created_by');
            $table->renameColumn('tanggal', 'tgl_pesan');
            
            // Add new columns
            $table->date('tgl_estimasi')->after('tgl_pesan');
            $table->decimal('subtotal', 15, 2)->default(0)->after('catatan');
            $table->decimal('ppn', 15, 2)->default(0)->after('subtotal');
            
            // Rename total_amount to total
            $table->renameColumn('total_amount', 'total');
            
            // Update status enum values
            $table->dropColumn('status');
        });
        
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->enum('status', ['pending', 'approved', 'rejected', 'completed'])->default('pending')->after('catatan');
            
            // Add approval workflow columns
            $table->foreignId('approved_by')->nullable()->after('created_by')->constrained('users');
            $table->timestamp('approved_at')->nullable()->after('approved_by');
            $table->text('reject_reason')->nullable()->after('approved_at');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('purchase_orders', function (Blueprint $table) {
            // Remove new columns
            $table->dropForeign(['approved_by']);
            $table->dropColumn(['tgl_estimasi', 'subtotal', 'ppn', 'approved_by', 'approved_at', 'reject_reason']);
            
            // Revert renames
            $table->renameColumn('no_po', 'nomor');
            $table->renameColumn('created_by', 'user_id');
            $table->renameColumn('tgl_pesan', 'tanggal');
            $table->renameColumn('total', 'total_amount');
            
            // Revert status enum
            $table->dropColumn('status');
        });
        
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->enum('status', ['draft', 'diproses', 'selesai', 'dibatalkan'])->after('tanggal');
        });
    }
};
