<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletes;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class NonPoIssue extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'no_dokumen',
        'recipient',
        'issue_date',
        'notes',
        'created_by'
    ];

    protected $casts = [
        'issue_date' => 'date'
    ];

    public function items(): HasMany
    {
        return $this->hasMany(NonPoIssueItem::class);
    }

    public function creator(): BelongsTo
    {
        return $this->belongsTo(User::class, 'created_by');
    }
}
