# API Documentation - DevFast Manager

## Authentication

### POST /api/auth/request-otp
Request an OTP code for registration.

**Body:**
```json
{
  "email": "user@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "expiresAt": "2024-01-01T12:00:00.000Z",
  "devCode": "123456"  // Only in development
}
```

---

### POST /api/auth/register
Register a new user.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "name": "User Name",
  "otp": "123456"
}
```

**Response:**
```json
{
  "user": {
    "id": 1,
    "email": "...",
    "name": "...",
    "role": "member",
    "avatar": null,
    "color": "#7C9CBF",
    "bio": null,
    "githubUrl": null,
    "facebookUrl": null,
    "linkedinUrl": null,
    "websiteUrl": null
  },
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

---

### POST /api/auth/login
Log in.

**Body:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```

**Response:** Same format as register.

---

### GET /api/auth/me
Get current user (requires authentication).

**Headers:**
```
Authorization: Bearer <token>
```

---

### PUT /api/auth/me
Update current user's profile.

**Body:**
```json
{
  "name": "New Name",
  "bio": "My bio",
  "avatar": "https://...",
  "color": "#FF5733",
  "githubUrl": "https://github.com/user",
  "facebookUrl": "https://facebook.com/user",
  "linkedinUrl": "https://linkedin.com/in/user",
  "websiteUrl": "https://mywebsite.com"
}
```

---

### GET /api/auth/users
List all users (requires authentication).

---

### GET /api/auth/users/:id
Get public profile of a user.

---

### GET /api/auth/roles
List all available roles.

---

### PUT /api/auth/users/:id/role
Change a user's role.

**Body:**
```json
{
  "roleId": 2
}
```

---

## Projects

### GET /api/projects
List all projects.

### GET /api/projects/:id
Get specific project with all data.

### POST /api/projects
Create a new project.

**Body:**
```json
{
  "name": "My Project",
  "description": "Description",
  "status": "ACTIVE",
  "publicUrl": "https://my-project.com"
}
```

### PUT /api/projects/:id
Update a project.

### DELETE /api/projects/:id
Delete a project.

### POST /api/projects/:id/metrics
Add user metrics.

**Body:**
```json
{
  "totalUsers": 100,
  "activeUsers": 50,
  "paidUsers": 20,
  "referralUsers": 10,
  "freeUsers": 70,
  "collaborationUsers": 5
}
```

---

## Infrastructure

### GET /api/vps/providers
List providers.

### POST /api/vps/providers
Create provider.

### GET /api/vps/servers
List VPS servers.

### POST /api/vps/servers
Create VPS server.

### POST /api/vps/servers/:id/link
Link server to project.

**Body:**
```json
{
  "projectId": 1,
  "costShare": 50
}
```

### GET /api/vps/items
List infrastructure items.

### POST /api/vps/items
Create item.

### GET /api/vps/costs
Monthly costs summary.

---

## Finances

### GET /api/finance/transactions
List transactions.

**Query params:**
- `projectId` - Filter by project
- `type` - INCOME or EXPENSE
- `startDate` - Start date
- `endDate` - End date

### POST /api/finance/transactions
Create transaction.

**Body:**
```json
{
  "projectId": 1,
  "type": "INCOME",
  "amount": 100.00,
  "currency": "USD",
  "description": "Client payment",
  "date": "2024-01-15"
}
```

### GET /api/finance/summary
General financial summary.

### GET /api/finance/rates/latest
Current exchange rates.

### POST /api/finance/rates
Add rate manually.

**Body:**
```json
{
  "code": "EUR",
  "rate": 0.85,
  "source": "manual"
}
```

---

## Tasks and Bugs

### GET /api/tasks/tasks
List tasks.

**Query params:**
- `projectId`
- `status`
- `assigneeId`

### POST /api/tasks/tasks
Create task.

**Body:**
```json
{
  "projectId": 1,
  "title": "New task",
  "description": "Description",
  "priority": "medium",
  "status": "PENDING",
  "assigneeId": 1,
  "dueDate": "2024-01-20"
}
```

### GET /api/tasks/bugs
List bugs.

### POST /api/tasks/bugs
Report bug.

**Body:**
```json
{
  "projectId": 1,
  "title": "Bug found",
  "description": "Bug description",
  "severity": "high",
  "status": "OPEN"
}
```

### GET /api/tasks/overview
Tasks and bugs overview.

---

## Dashboard

### GET /api/dashboard
System overview.

### GET /api/dashboard/alerts
System alerts list.

### GET /api/dashboard/exchange-rate/fetch
Force exchange rate update.

### GET /api/dashboard/charts/income-expense
Income/expense chart.

**Query params:**
- `months` - Number of months (default 6)

### GET /api/dashboard/charts/project-performance
Project performance.

---

## Chat

### GET /api/chat/channels
List user's channels.

### GET /api/chat/channels/:id/messages
Channel messages.

### POST /api/chat/channels/:id/messages
Send message.

**Body:**
```json
{
  "content": "Hello team!"
}
```

### POST /api/chat/private
Create private channel with another user.

**Body:**
```json
{
  "userId": 2
}
```

### WebSocket /api/chat/ws
Connect to real-time chat.

**URL:**
```
ws://host/api/chat/ws?token=<jwt_token>
```

**Messages (send):**
```json
{
  "type": "message",
  "channelId": 1,
  "content": "Message"
}
```

**Messages (receive):**
```json
{
  "type": "new_message",
  "channelId": 1,
  "message": { ... }
}
```

---

## Settings

### GET /api/settings/company
Get company configuration.

### PUT /api/settings/company
Update configuration.

**Body:**
```json
{
  "companyName": "My Company",
  "companyObjective": "Manager objective",
  "companyLogoUrl": "https://logo.png"
}
```

---

## Error Codes

| Code | Meaning |
|------|---------|
| 400 | Invalid request |
| 401 | Unauthorized |
| 403 | Forbidden |
| 404 | Not found |
| 500 | Server error |