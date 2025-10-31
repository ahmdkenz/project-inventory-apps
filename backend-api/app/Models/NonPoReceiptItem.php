<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class NonPoReceiptItem extends Model
{
    protected $fillable = [
        'non_po_receipt_id',
        'barang_id',
        'qty',
        'price',
        'subtotal'
    ];

    protected $casts = [
        'qty' => 'integer',
        'price' => 'decimal:2',
        'subtotal' => 'decimal:2'
    ];

    public function receipt(): BelongsTo
    {
        return $this->belongsTo(NonPoReceipt::class, 'non_po_receipt_id');
    }

    public function barang(): BelongsTo
    {
        return $this->belongsTo(Barang::class);
    }
}
