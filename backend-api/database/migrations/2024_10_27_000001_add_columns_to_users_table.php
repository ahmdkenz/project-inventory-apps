<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            // Add new columns
            $table->string('username')->unique()->after('name');
            $table->enum('role', ['admin', 'staff'])->after('password');
            $table->string('phone')->nullable()->after('role');
            $table->text('address')->nullable()->after('phone');
            $table->softDeletes();
        });
    }

    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['username', 'role', 'phone', 'address', 'deleted_at']);
        });
    }
};