<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class NonPoReceipt extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'no_dokumen',
        'source',
        'receive_date',
        'notes',
        'total_value',
        'created_by',
        'status',
        'approved_by',
        'approved_at',
        'reject_reason'
    ];

    protected $casts = [
        'receive_date' => 'date',
        'total_value' => 'decimal:2',
        'approved_at' => 'datetime'
    ];

    public function items(): HasMany
    {
        return $this->hasMany(NonPoReceiptItem::class);
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
