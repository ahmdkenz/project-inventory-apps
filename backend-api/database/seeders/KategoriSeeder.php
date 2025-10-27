<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Kategori;

class KategoriSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $kategoriData = [
            [
                'nama' => 'ATK',
                'kode' => 'ATK',
                'deskripsi' => 'Alat Tulis Kantor'
            ],
            [
                'nama' => 'Elektronik',
                'kode' => 'ELK',
                'deskripsi' => 'Barang Elektronik'
            ],
            [
                'nama' => 'Perlengkapan Dapur',
                'kode' => 'DPR',
                'deskripsi' => 'Perlengkapan dan Peralatan Dapur'
            ],
            [
                'nama' => 'Lainnya',
                'kode' => 'LNY',
                'deskripsi' => 'Kategori Lainnya'
            ]
        ];

        foreach ($kategoriData as $kategori) {
            Kategori::create($kategori);
        }
    }
}
