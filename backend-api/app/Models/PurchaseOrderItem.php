<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class PurchaseOrderItem extends Model
{
    protected $fillable = [
        'purchase_order_id',
        'barang_id',
        'qty',
        'qty_received',
        'harga_satuan',
        'subtotal',
        'catatan'
    ];

    /**
     * Get the purchase order
     */
    public function purchaseOrder(): BelongsTo
    {
        return $this->belongsTo(PurchaseOrder::class);
    }

    /**
     * Get the barang
     */
    public function barang(): BelongsTo
    {
        return $this->belongsTo(Barang::class);
    }
}
