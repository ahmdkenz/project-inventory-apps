<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->string('no_surat_jalan')->nullable()->after('catatan');
        });

        Schema::table('purchase_order_items', function (Blueprint $table) {
            $table->integer('qty_received')->nullable()->after('qty');
        });
    }

    public function down()
    {
        Schema::table('purchase_orders', function (Blueprint $table) {
            $table->dropColumn('no_surat_jalan');
        });

        Schema::table('purchase_order_items', function (Blueprint $table) {
            $table->dropColumn('qty_received');
        });
    }
};
