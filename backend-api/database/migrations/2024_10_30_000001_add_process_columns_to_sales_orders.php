<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('sales_orders', function (Blueprint $table) {
            $table->timestamp('completed_at')->nullable()->after('approved_at');
            $table->text('catatan_pengeluaran')->nullable()->after('reject_reason');
        });

        Schema::table('sales_order_items', function (Blueprint $table) {
            $table->integer('qty_issued')->nullable()->after('qty');
        });
    }

    public function down()
    {
        Schema::table('sales_orders', function (Blueprint $table) {
            $table->dropColumn(['completed_at', 'catatan_pengeluaran']);
        });

        Schema::table('sales_order_items', function (Blueprint $table) {
            $table->dropColumn('qty_issued');
        });
    }
};
