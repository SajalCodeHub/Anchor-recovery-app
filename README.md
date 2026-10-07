@'
<div align="center">

# ⚓ ANCHOR

### A Free, Privacy-First Habit & Addiction Recovery Companion

**SE641 / CSCI695 — Application and Database Systems**  
**St. Cloud State University • Fall 2026**

<br>

![Academic Project](https://img.shields.io/badge/Academic%20Project-Fall%202026-4F46E5)
![Privacy First](https://img.shields.io/badge/Privacy-First-16A34A)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-Database-336791?logo=postgresql&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase&logoColor=white)
![Redis](https://img.shields.io/badge/Redis-Caching-DC382D?logo=redis&logoColor=white)
![Status](https://img.shields.io/badge/Status-In%20Development-F59E0B)

<br>

**Recovery tracking • Private journaling • Crisis support • Anonymous encouragement**

</div>

---

## 📖 About ANCHOR

**ANCHOR** is a database-backed habit and addiction recovery application designed to provide users with **free, private, and accessible tools** for recovery tracking, reflection, and peer encouragement.

Many existing recovery applications provide useful accountability tools but place important functionality behind recurring subscription fees. At the same time, these applications may collect highly sensitive information such as relapse history, emotional triggers, locations, and personal journal entries.

ANCHOR addresses both concerns by providing a **free, open, and privacy-first recovery companion** where privacy and data isolation are treated as fundamental system requirements.

---

## 🎯 Project Goals

ANCHOR is designed to:

- 📈 Provide real-time habit and recovery tracking
- ✅ Support daily check-ins and sobriety streak monitoring
- 🆘 Provide immediate support during high-risk moments
- 📝 Allow users to privately record triggers and recovery experiences
- 🔎 Provide fast search across private journal entries
- 🤝 Support anonymous peer encouragement
- 🔐 Protect sensitive information through database-level security
- 🗄️ Demonstrate advanced database concepts beyond basic CRUD operations

---

## ✨ Core Features

| Feature | Description |
|---|---|
| 📊 **Streak & Log Dashboard** | Tracks daily check-ins, sobriety streaks, relapse events, urges, and recovery trends |
| 🆘 **Emergency Panic Button** | Provides motivational messages, grounding prompts, and personal reminders during high-risk moments |
| 📝 **Trigger Journaling & Search** | Allows users to privately record triggers, stress levels, locations, notes, and recovery experiences |
| 🤝 **Anonymous Support Feed** | Provides a pseudonymous community where users can give and receive encouragement without exposing sensitive recovery information |

---

## 🛠️ Technology Stack

<div align="center">

| Category | Technologies |
|---|---|
| **Primary Database** | PostgreSQL |
| **Database Platform** | Supabase |
| **Caching** | Redis / Upstash Redis |
| **Authentication** | Supabase Authentication |
| **API Support** | REST / GraphQL |
| **Flexible Data** | PostgreSQL JSONB |
| **Search** | PostgreSQL Full-Text Search |
| **Security** | Row-Level Security (RLS) |
| **Analytics** | Materialized Views & Time-Series Partitioning |

</div>

---

## 🗄️ Database Design

ANCHOR is designed to go beyond standard **Create, Read, Update, and Delete (CRUD)** operations.

### Basic Operations

CRUD operations will support:

- User profiles
- Daily check-ins
- Journal entries
- Community posts

### Advanced Database Operations

| Database Technique | Purpose |
|---|---|
| **Time-Series Partitioning** | Partitions check-in and urge logs by time period so analytics remain efficient as data grows |
| **Redis Caching** | Caches active streak information and motivational content for low-latency responses |
| **JSONB** | Supports flexible storage of journal-related information |
| **Full-Text Search** | Enables fast keyword searching across private journal entries |
| **Row-Level Security (RLS)** | Helps ensure users can access only the data they are authorized to access |
| **Materialized Views** | Precomputes streak and engagement statistics for faster dashboard analytics |
| **Query-Optimized Indexes** | Improves performance of commonly executed database queries |

---

## 🧩 Project Development Areas

The application is divided into several major development areas.

| Development Area | Primary Responsibilities |
|---|---|
| 🔐 **Authentication, Privacy & Security** | Authentication, RLS policies, field protection, session handling, and user data isolation |
| 🔥 **Streak Engine & Core Daily Logs** | Daily check-ins, streak calculations, recovery history, materialized views, and related APIs |
| 🆘 **Panic Button & Redis Caching** | Panic Button endpoint, motivational content, Redis caching, and event logging |
| 📝 **Journaling, Search & Anonymous Feed** | JSONB journal storage, full-text search, pseudonymous posting, and anonymous peer support |
| 📈 **Time-Series Analytics & Trend Engine** | Table partitioning, query optimization, analytics APIs, and recovery trend analysis |
| 🧪 **Integration & Quality Assurance** | Cross-feature integration, testing, security verification, database validation, and deployment preparation |

---

## 🚦 Development Workflow

Development is coordinated using:

- **GitHub Issues**
- **GitHub Project Board**
- **Feature Branches**
- **Pull Requests**
- **Code Review**
- **Testing & QA**

### Task Status Flow

```text
┌─────────────────────┐
│     Not Started     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│     In Progress     │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│ Ready for Integration│
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│       Tested        │
└──────────┬──────────┘
           ↓
┌─────────────────────┐
│        Done         │
└─────────────────────┘
```

### Status Definitions

| Status | Meaning |
|---|---|
| ⚪ **Not Started** | Task has been identified but development has not started |
| 🔵 **In Progress** | A team member is actively working on the task |
| 🟣 **Ready for Integration** | Development is complete and ready to be reviewed or integrated |
| 🟡 **Tested** | The integrated feature has been reviewed and tested |
| 🟢 **Done** | The task has been successfully completed and accepted |

> **Live task progress will be maintained through the ANCHOR GitHub Project Board.**

---

## 🔄 Development Process

```text
Create GitHub Issue
        ↓
Assign Team Member
        ↓
Move to In Progress
        ↓
Create Feature Branch
        ↓
Develop Feature
        ↓
Commit Changes
        ↓
Push Feature Branch
        ↓
Open Pull Request
        ↓
Ready for Integration
        ↓
Review & Integrate
        ↓
Test Feature
        ↓
Move to Tested
        ↓
Merge into Main
        ↓
Done
```

---

## 🌿 Branching Strategy

The `main` branch represents the stable integrated version of the project.

Development work should be completed using feature branches.

Example:

```text
main
│
├── feature/authentication
├── feature/rls-security
├── feature/streak-engine
├── feature/panic-button
├── feature/journal-search
├── feature/anonymous-feed
└── feature/analytics
```

Major development work should **not be performed directly on `main`**.

Completed features should be integrated through **Pull Requests**.

---

## 🤝 Collaboration Guidelines

Team members should:

- Create or work from assigned GitHub Issues
- Keep their task status updated
- Use feature branches
- Use meaningful commit messages
- Push work regularly
- Open Pull Requests when features are ready
- Review changes before integration
- Test integrated features
- Document important technical decisions
- Communicate blockers or dependencies with the team
- Avoid overwriting another member's work

---

## 🗓️ Development Timeline

| Sprint | Weeks | Focus |
|---|:---:|---|
| **Sprint 0** | 1–2 | Baseline schema, environment setup, wireframes, and minimal authentication |
| **Sprint 1** | 3–6 | Parallel development of the four primary feature areas |
| **Sprint 2** | 7–8 | Time-Series Analytics & Trend Engine |
| **Sprint 3** | 9–10 | Feature Hardening & Cross-Feature Polish |
| **Sprint 4** | 11–12 | Integration |
| **Sprint 5** | 13–14 | Final Testing, Deployment, and Documentation |

> 🧪 **Testing and Quality Assurance run continuously throughout development rather than only during the final sprint.**

---

## 📁 Planned Repository Structure

```text
Anchor-recovery-app/
│
├── README.md
├── .gitignore
│
├── docs/
│   ├── architecture/
│   ├── database-design/
│   └── project-documentation/
│
├── database/
│   ├── schema/
│   ├── migrations/
│   ├── rls/
│   ├── views/
│   └── seed/
│
├── backend/
│
├── frontend/
│
├── tests/
│
└── scripts/
```

The repository structure may evolve as implementation decisions are finalized.

---

## 👥 Team

<div align="center">

| Team Member |
|---|
| **Sahar Atie** |
| **Anastasiya Gorlov** |
| **Kehinde O. Ayeyemi** |
| **Sajal Bhattarai** |
| **Assan Saidy** |

</div>

---

## 📚 Course Information

| | |
|---|---|
| **Course** | SE641 / CSCI695 — Application and Database Systems |
| **Institution** | St. Cloud State University |
| **Semester** | Fall 2026 |
| **Project** | ANCHOR |

---

## 🚧 Current Status

> ### Initial Development / Project Setup

The team is currently establishing:

- ✅ GitHub repository
- 🔄 Team collaboration access
- 🔄 GitHub Project Board
- 🔄 Development workflow
- 🔄 Database structure
- 🔄 Development environment

---

## 🎓 Academic Purpose

ANCHOR is being developed as an academic project for **SE641 / CSCI695 — Application and Database Systems**.

The project demonstrates practical experience with:

- Relational database design
- Advanced PostgreSQL functionality
- Database security
- Caching
- Search
- Analytics
- Application integration
- Collaborative software development

---

## ⚠️ Disclaimer

ANCHOR is an academic software project intended to support habit and addiction recovery tracking and reflection.

It is **not intended to replace professional medical, psychological, addiction-treatment, crisis, or emergency services**.

---

<div align="center">

### ⚓ ANCHOR

**Private by Design • Accessible by Purpose • Built for Recovery**

St. Cloud State University • Fall 2026

</div>
'@ | Set-Content -Path README.md -Encoding UTF8

git add README.md
git commit -m "Redesign README with professional project layout"
git push origin main