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
        Schema::table('non_po_receipts', function (Blueprint $table) {
            $table->string('no_surat_jalan')->nullable()->after('notes');
            $table->timestamp('received_at')->nullable()->after('approved_at');
            $table->unsignedBigInteger('received_by')->nullable()->after('received_at');
            
            $table->foreign('received_by')->references('id')->on('users')->onDelete('set null');
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('non_po_receipts', function (Blueprint $table) {
            $table->dropForeign(['received_by']);
            $table->dropColumn(['no_surat_jalan', 'received_at', 'received_by']);
        });
    }
};
