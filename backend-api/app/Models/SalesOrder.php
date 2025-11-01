<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class SalesOrder extends Model
{
    protected $fillable = [
        'no_so',
        'customer_name',
        'customer_phone',
        'customer_address',
        'tgl_order',
        'tgl_kirim',
        'catatan',
        'status',
        'subtotal',
        'ppn',
        'total',
        'created_by',
        'approved_by',
        'approved_at',
        'completed_at',
        'no_surat_jalan',
        'catatan_pengeluaran',
        'reject_reason',
    ];

    protected $casts = [
        'tgl_order' => 'date',
        'tgl_kirim' => 'date',
        'approved_at' => 'datetime',
        'completed_at' => 'datetime',
        'subtotal' => 'decimal:2',
        'ppn' => 'decimal:2',
        'total' => 'decimal:2',
    ];

    public function items(): HasMany
    {
        return $this->hasMany(SalesOrderItem::class);
    }

    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    public function approver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by');
    }
}
