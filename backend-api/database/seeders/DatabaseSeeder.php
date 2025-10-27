<?php

namespace Database\Seeders;

use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create default admin user
        User::create([
            'name' => 'Administrator',
            'username' => 'admin',
            'email' => 'admin@example.com',
            'password' => bcrypt('admin123'),
            'role' => 'admin',
            'phone' => '081234567890',
            'address' => 'Jl. Admin No. 1'
        ]);

        // Create default staff user
        User::create([
            'name' => 'Staff Gudang',
            'username' => 'staff',
            'email' => 'staff@example.com',
            'password' => bcrypt('staff123'),
            'role' => 'staff',
            'phone' => '081234567891',
            'address' => 'Jl. Staff No. 1'
        ]);

        // Create default categories
        $categories = [
            [
                'nama' => 'Elektronik',
                'kode' => 'ELK',
                'deskripsi' => 'Kategori untuk barang elektronik'
            ],
            [
                'nama' => 'Alat Tulis',
                'kode' => 'ATK',
                'deskripsi' => 'Kategori untuk alat tulis kantor'
            ],
            [
                'nama' => 'Furniture',
                'kode' => 'FUR',
                'deskripsi' => 'Kategori untuk furniture dan perabotan'
            ],
            [
                'nama' => 'Spare Part',
                'kode' => 'SPT',
                'deskripsi' => 'Kategori untuk spare part dan komponen'
            ]
        ];

        foreach ($categories as $category) {
            \App\Models\Kategori::create($category);
        }
    }
}
