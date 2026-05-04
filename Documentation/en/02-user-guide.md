# User Guide - DevFast Manager

## Introduction

DevFast Manager is a comprehensive management system that allows you to administer projects, infrastructure, finance, team, and tasks from a single platform.

## Navigation

The sidebar menu contains:
- **Dashboard**: System overview
- **Projects**: Project management
- **Infrastructure**: VPS and servers
- **Finances**: Transactions and metrics
- **Tasks**: Tasks and bugs
- **Team**: Team members
- **Chat**: Internal communication
- **Notifications**: System activity
- **My Profile**: Personal settings
- **Company**: Organization settings

## Main Features

### Dashboard

Shows a summary of:
- Total income and expenses
- Active projects
- Servers and infrastructure costs
- System alerts (VPS without project, critical bugs, overdue tasks)
- Financial trends chart

### Projects

**Creating a project:**
1. Go to Projects
2. Click "New Project"
3. Fill: name, description, state, public URL
4. Assign members and define responsible persons

**Project states:**
- ACTIVE: In active development
- RENTABLE: Generating revenue
- PAUSED: Temporarily paused
- ABANDONED: Abandoned
- EXPERIMENTAL: In testing

### Infrastructure

**VPS Servers:**
- Add servers with IP, provider, monthly cost
- Link each server to one or more projects
- Define the cost percentage each project assumes

**Infrastructure items:**
- Domains, SSL certificates, databases, etc.
- Project association similar to VPS

### Finances

**Transactions:**
- Record income and expenses
- Select currency (USD, EUR, CUP, USDT, MLC)
- Associate with a specific project

**Exchange rates:**
- Automatically updated from El Toque every 24h
- You can also add them manually

### Tasks and Bugs

**Tasks:**
- Create, edit, delete
- Assign to team members
- Define priority (low, medium, high)
- States: Pending, In Progress, Completed, Cancelled

**Bugs:**
- Report bugs with severity (low, medium, high, critical)
- States: Open, In Progress, Resolved, Closed

### Team

- View all team members
- Change roles (admin, founder, cofounder, developer, etc.)
- View projects assigned to each member
- Access public profile of each user

### Chat

- **Company Channel**: For all members
- **Co-founders Channel**: Only for leadership roles
- **Private**: Conversations between two people
- Real-time messages (WebSocket)

### Personal Profile

Editable in "My Profile":
- Name
- Profile photo (URL)
- Custom color
- Bio / description
- Links: GitHub, Facebook, LinkedIn, Website

## Dark Mode

Click the sun/moon icon in the header to toggle between light and dark mode. The preference is saved in your browser.

## Company Settings

In the "Company" section (administrators only):
- Organization name
- Manager objective
- Logo (URL)

This configuration appears on the login, header, and throughout the application.

## Tips

1. **Use alerts**: The dashboard shows important warnings
2. **Register transactions**: Keep financial control updated
3. **Link resources**: Associate VPS and infrastructure to projects to see actual costs
4. **Update metrics**: Regularly record users for each project
5. **Check notifications**: Stay up to date with team activity