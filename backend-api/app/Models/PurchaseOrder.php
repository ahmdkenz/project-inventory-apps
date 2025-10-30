<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class PurchaseOrder extends Model
{
    protected $fillable = [
        'no_po',
        'supplier_id',
        'tgl_pesan',
        'tgl_estimasi',
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
        'reject_reason'
    ];

    protected $casts = [
        'tgl_pesan' => 'date',
        'tgl_estimasi' => 'date',
        'approved_at' => 'datetime',
        'completed_at' => 'datetime',
    ];

    /**
     * Get the supplier
     */
    public function supplier(): BelongsTo
    {
        return $this->belongsTo(Supplier::class);
    }

    /**
     * Get the items
     */
    public function items(): HasMany
    {
        return $this->hasMany(PurchaseOrderItem::class);
    }

    /**
     * Get the creator
     */
    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }

    /**
     * Get the approver
     */
    public function approver(): BelongsTo
    {
        return $this->belongsTo(User::class, 'approved_by');
    }

    /**
     * Generate PO number
     */
    public static function generatePONumber(): string
    {
        $year = date('Y');
        $month = date('m');
        $lastPO = self::whereYear('created_at', $year)
            ->whereMonth('created_at', $month)
            ->orderBy('id', 'desc')
            ->first();

        $sequence = $lastPO ? ((int) substr($lastPO->no_po, -4)) + 1 : 1;
        
        return sprintf('PO-%s%s-%04d', $year, $month, $sequence);
    }
}
