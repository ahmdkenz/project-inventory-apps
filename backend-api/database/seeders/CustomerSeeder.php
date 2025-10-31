<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use App\Models\Customer;

class CustomerSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $customers = [
            [
                'company_name' => 'PT. Jaya Abadi',
                'contact_name' => 'Budi Santoso',
                'email' => 'budi@jayaabadi.com',
                'phone' => '081234567890',
                'address' => 'Jl. Mangga Dua Raya No. 12',
                'city' => 'Jakarta Utara',
                'zipcode' => '14430'
            ],
            [
                'company_name' => 'CV. Sinar Terang',
                'contact_name' => 'Anita Dewi',
                'email' => 'anita@sinarterang.com',
                'phone' => '085611223344',
                'address' => 'Jl. Gajah Mada No. 101',
                'city' => 'Surabaya',
                'zipcode' => '60175'
            ],
            [
                'company_name' => 'Toko Makmur Jaya',
                'contact_name' => 'Rudi Hartono',
                'email' => 'rudi@makmurjaya.com',
                'phone' => '082198765432',
                'address' => 'Jl. Ahmad Yani No. 45',
                'city' => 'Bandung',
                'zipcode' => '40124'
            ]
        ];

        foreach ($customers as $customer) {
            Customer::create($customer);
        }
    }
}
