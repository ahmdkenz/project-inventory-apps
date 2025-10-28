import api from './api'

export interface AuditLog {
  id: number
  user_id: number | null
  username: string
  action: string
  description: string
  entity_type: string | null
  entity_id: number | null
  ip_address: string | null
  user_agent: string | null
  created_at: string
  updated_at: string
  user?: {
    id: number
    name: string
    username: string
    email: string
  }
}

export interface AuditLogFilters {
  username?: string
  action?: string
  date_start?: string
  date_end?: string
  entity_type?: string
  per_page?: number
  page?: number
}

const auditLogService = {
  /**
   * Get all audit logs with filters
   */
  async getAll(filters: AuditLogFilters = {}) {
    const response = await api.get('/admin/audit-logs', { params: filters })
    return response.data
  },

  /**
   * Get recent activities for dashboard
   */
  async getRecent(limit: number = 10) {
    const response = await api.get('/admin/audit-logs/recent', { params: { limit } })
    return response.data
  }
}

export default auditLogService
