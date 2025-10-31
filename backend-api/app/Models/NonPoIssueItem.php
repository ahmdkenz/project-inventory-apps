<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class NonPoIssueItem extends Model
{
    protected $fillable = [
        'non_po_issue_id',
        'barang_id',
        'qty'
    ];

    protected $casts = [
        'qty' => 'integer'
    ];

    public function issue(): BelongsTo
    {
        return $this->belongsTo(NonPoIssue::class, 'non_po_issue_id');
    }

    public function barang(): BelongsTo
    {
        return $this->belongsTo(Barang::class);
    }
}
