<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::create('purchase_orders', function (Blueprint $table) {
            $table->id();
            $table->string('nomor')->unique();
            $table->foreignId('supplier_id')->constrained('supplier');
            $table->foreignId('user_id')->constrained('users');
            $table->date('tanggal');
            $table->enum('status', ['draft', 'diproses', 'selesai', 'dibatalkan']);
            $table->decimal('total_amount', 15, 2);
            $table->text('catatan')->nullable();
            $table->timestamps();
            $table->softDeletes();
        });

        Schema::create('purchase_order_items', function (Blueprint $table) {
            $table->id();
            $table->foreignId('purchase_order_id')->constrained('purchase_orders')->onDelete('cascade');
            $table->foreignId('barang_id')->constrained('barang');
            $table->integer('jumlah');
            $table->decimal('harga', 15, 2);
            $table->decimal('subtotal', 15, 2);
            $table->text('catatan')->nullable();
            $table->timestamps();
        });
    }

    public function down()
    {
        Schema::dropIfExists('purchase_order_items');
        Schema::dropIfExists('purchase_orders');
    }
};