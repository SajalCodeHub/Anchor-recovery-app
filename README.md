# \# ANCHOR

# 

# \### A Free, Privacy-First Habit \& Addiction Recovery Companion

# 

# ANCHOR is a database-backed habit and addiction recovery application designed to provide users with free, private, and accessible tools for recovery tracking, reflection, and peer encouragement.

# 

# This project is being developed for \*\*SE641 / CSCI695 – Application and Database Systems\*\* at \*\*St. Cloud State University\*\*.

# 

# \---

# 

# \## Overview

# 

# Many habit and addiction recovery applications provide useful features such as sobriety streak tracking, trigger logging, personal reminders, and daily accountability. However, important accountability features are often placed behind recurring subscription fees.

# 

# ANCHOR is designed as a \*\*free, open, and privacy-first recovery companion\*\*.

# 

# The application focuses on protecting highly sensitive user information such as:

# 

# \- Recovery history

# \- Relapse dates

# \- Emotional triggers

# \- High-risk situations

# \- Personal journal entries

# \- User activity and recovery patterns

# 

# Privacy is treated as a core system requirement rather than only an application-level feature. Sensitive information is intended to be protected through database-level controls and data isolation.

# 

# \---

# 

# \## Project Goals

# 

# ANCHOR aims to:

# 

# \- Provide real-time habit and recovery tracking

# \- Support daily check-ins and sobriety streak monitoring

# \- Provide immediate support during high-risk moments

# \- Allow users to privately record and search triggers and experiences

# \- Support anonymous peer encouragement

# \- Protect sensitive user information through database-level security

# \- Demonstrate advanced database design and implementation concepts beyond basic CRUD operations

# 

# \---

# 

# \## Core Features

# 

# \### Streak \& Log Dashboard

# 

# The dashboard provides users with recovery-related tracking and analytics, including:

# 

# \- Daily recovery check-ins

# \- Sobriety streaks

# \- Relapse tracking

# \- Urge trends

# \- Time-series recovery analytics

# 

# \### Emergency Panic Button

# 

# The Panic Button is intended to provide immediate support during high-risk moments.

# 

# When activated, it can provide:

# 

# \- Motivational messages

# \- Grounding prompts

# \- Personal recovery reminders

# \- Personal goals

# 

# The feature is designed to provide a low-latency response.

# 

# \### Trigger Journaling \& Search

# 

# Users can privately record information related to high-risk situations, including:

# 

# \- Triggers

# \- Stress levels

# \- Personal notes

# \- Locations

# \- Recovery experiences

# 

# Journal entries will support keyword and full-text search.

# 

# \### Anonymous Support Feed

# 

# Users can post and receive encouragement through a pseudonymous community feed.

# 

# The goal is to allow peer support without exposing a user's identity or sensitive recovery history.

# 

# \---

# 

# \## Technology Stack

# 

# \### Database

# 

# \- PostgreSQL

# \- Supabase

# 

# \### Database Features

# 

# \- Row-Level Security (RLS)

# \- JSONB

# \- PostgreSQL Full-Text Search

# \- Materialized Views

# \- Time-Series Partitioning

# \- Query Optimization

# \- Indexing

# 

# \### Caching

# 

# \- Redis

# \- Upstash Redis

# 

# \### API / Backend Support

# 

# \- Supabase Authentication

# \- REST APIs

# \- GraphQL APIs

# 

# Additional frontend and backend technologies may be added as development progresses.

# 

# \---

# 

# \## Database Design

# 

# ANCHOR uses PostgreSQL as its primary database platform, hosted through Supabase.

# 

# The project is designed to go beyond standard CRUD functionality by implementing advanced database techniques.

# 

# \### Basic Operations

# 

# The system supports create, read, update, and delete operations for:

# 

# \- User profiles

# \- Daily check-ins

# \- Journal entries

# \- Community posts

# 

# \### Advanced Operations

# 

# \#### Time-Series Partitioning

# 

# Check-in and urge logs can be partitioned by month or year so analytics queries remain efficient as data volume grows.

# 

# \#### In-Memory Caching

# 

# Frequently accessed information such as active streak state and motivational content can be cached using Redis to improve response time.

# 

# \#### JSONB + Full-Text Search

# 

# Flexible journal data can be stored using PostgreSQL JSONB while full-text indexes support efficient keyword searching.

# 

# \#### Row-Level Security

# 

# PostgreSQL Row-Level Security policies are used to help ensure that sensitive records remain isolated between users.

# 

# \#### Materialized Views

# 

# Precomputed streak and engagement statistics can be stored in materialized views to reduce expensive calculations on every dashboard request.

# 

# \---

# 

# \## Development Workflow

# 

# Development work is managed through:

# 

# \- GitHub Issues

# \- GitHub Project Board

# \- Feature Branches

# \- Pull Requests

# \- Testing and Review

# 

# Each task moves through the following status workflow:

# 

# ```text

# Not Started

# &#x20;   ↓

# In Progress

# &#x20;   ↓

# Ready for Integration

# &#x20;   ↓

# Tested

# &#x20;   ↓

# Done

# ```

# 

# \### Status Definitions

# 

# | Status | Meaning |

# |---|---|

# | \*\*Not Started\*\* | The task has been created but work has not started |

# | \*\*In Progress\*\* | A team member is actively working on the task |

# | \*\*Ready for Integration\*\* | Development is complete and the work is ready to be merged or integrated |

# | \*\*Tested\*\* | The integrated feature has been reviewed and tested |

# | \*\*Done\*\* | The task has been fully completed and accepted |

# 

# The actual live task status will be maintained on the \*\*GitHub Project Board\*\*.

# 

# \---

# 

# \## Project Development Areas

# 

# The project is divided into the following main development areas.

# 

# \### Authentication, Privacy \& Security

# 

# This area includes:

# 

# \- Authentication

# \- Row-Level Security policies

# \- Field protection

# \- Session handling

# \- User data isolation

# 

# \### Streak Engine \& Core Daily Logs

# 

# This area includes:

# 

# \- Daily check-in schema

# \- Streak calculations

# \- Recovery history

# \- Materialized views

# \- Streak-related APIs

# 

# \### Panic Button \& Redis Caching

# 

# This area includes:

# 

# \- Panic Button endpoint

# \- Motivational content

# \- Redis caching

# \- Event logging

# \- Low-latency response handling

# 

# \### Journaling, Search \& Anonymous Feed

# 

# This area includes:

# 

# \- Journal data model

# \- JSONB storage

# \- Full-text search

# \- Pseudonymous posting

# \- Anonymous community support

# 

# \### Time-Series Analytics \& Trend Engine

# 

# This area includes:

# 

# \- Table partitioning

# \- Query optimization

# \- Analytics queries

# \- Trend calculations

# \- Recovery pattern analysis

# 

# \### Integration \& Quality Assurance

# 

# This area includes:

# 

# \- Cross-feature integration

# \- Testing

# \- Security verification

# \- Database validation

# \- Deployment preparation

# 

# \---

# 

# \## Development Timeline

# 

# The project follows a sprint-based development process.

# 

# \### Sprint 0 — Weeks 1–2

# 

# \*\*Kickoff\*\*

# 

# \- Baseline schema design

# \- Environment setup

# \- Wireframes

# \- Minimal authentication and user table

# 

# \### Sprint 1 — Weeks 3–6

# 

# Parallel development of:

# 

# \- Authentication, Privacy \& Security

# \- Streak Engine \& Core Daily Logs

# \- Panic Button \& Redis Caching

# \- Journaling, Search \& Anonymous Feed

# 

# \### Sprint 2 — Weeks 7–8

# 

# \*\*Time-Series Analytics \& Trend Engine\*\*

# 

# \- Table partitioning

# \- Query-optimized indexes

# \- Analytics APIs

# 

# \### Sprint 3 — Weeks 9–10

# 

# \*\*Feature Hardening \& Cross-Feature Polish\*\*

# 

# \- Refine existing features

# \- Improve reliability

# \- Resolve integration gaps

# \- Strengthen database operations

# 

# \### Sprint 4 — Weeks 11–12

# 

# \*\*Integration\*\*

# 

# \- Integrate database features

# \- Merge security policies

# \- Integrate partitioning

# \- Integrate materialized views

# \- Resolve cross-feature issues

# 

# \### Sprint 5 — Weeks 13–14

# 

# \*\*Final Testing \& Deployment\*\*

# 

# \- End-to-end testing

# \- Final deployment

# \- Documentation

# \- Quality assurance

# 

# Testing and QA are intended to run continuously throughout the project.

# 

# \---

# 

# \## Team Collaboration

# 

# All team members are expected to use GitHub for collaboration and project tracking.

# 

# Team members should:

# 

# \- Work from assigned GitHub Issues

# \- Keep task status updated on the GitHub Project Board

# \- Use feature branches for development

# \- Avoid making major changes directly to the `main` branch

# \- Open Pull Requests when work is ready for integration

# \- Review and test changes before marking tasks complete

# \- Use clear and meaningful commit messages

# \- Document important technical decisions

# \- Communicate blockers or integration issues with the team

# 

# \---

# 

# \## Branching Strategy

# 

# Development should be performed using feature branches.

# 

# Example:

# 

# ```text

# main

# 

# feature/authentication

# feature/rls-security

# feature/streak-engine

# feature/panic-button

# feature/journal-search

# feature/anonymous-feed

# feature/analytics

# ```

# 

# A typical development workflow is:

# 

# ```text

# Create Issue

# &#x20;   ↓

# Assign Team Member

# &#x20;   ↓

# Move to In Progress

# &#x20;   ↓

# Create Feature Branch

# &#x20;   ↓

# Develop Feature

# &#x20;   ↓

# Commit Changes

# &#x20;   ↓

# Push Branch

# &#x20;   ↓

# Open Pull Request

# &#x20;   ↓

# Move to Ready for Integration

# &#x20;   ↓

# Review / Integrate

# &#x20;   ↓

# Test

# &#x20;   ↓

# Move to Tested

# &#x20;   ↓

# Merge into Main

# &#x20;   ↓

# Move to Done

# ```

# 

# \---

# 

# \## Repository Structure

# 

# The repository structure will evolve as development progresses.

# 

# A possible structure is:

# 

# ```text

# anchor-recovery-app/

# │

# ├── README.md

# ├── .gitignore

# │

# ├── docs/

# │   ├── architecture/

# │   ├── database-design/

# │   └── project-documentation/

# │

# ├── database/

# │   ├── schema/

# │   ├── migrations/

# │   ├── rls/

# │   ├── views/

# │   └── seed/

# │

# ├── backend/

# │

# ├── frontend/

# │

# ├── tests/

# │

# └── scripts/

# ```

# 

# \---

# 

# \## Team Members

# 

# \- Sahar Atie

# \- Anastasiya Gorlov

# \- Kehinde O. Ayeyemi

# \- Sajal Bhattarai

# \- Assan Saidy

# 

# \---

# 

# \## Course Information

# 

# \*\*Course:\*\* SE641 / CSCI695 – Application and Database Systems  

# \*\*Institution:\*\* St. Cloud State University  

# \*\*Semester:\*\* Fall 2026

# 

# \---

# 

# \## Project Status

# 

# \*\*Current Status:\*\* Initial Development / Project Setup

# 

# The team is currently setting up:

# 

# \- GitHub repository

# \- Team collaboration access

# \- GitHub Project Board

# \- Development workflow

# \- Database structure

# \- Development environment

# 

# \---

# 

# \## Academic Purpose

# 

# This project is being developed as part of an academic course project and is intended to demonstrate practical application and database system design skills.

# 

# \---

# 

# \## License

# 

# Licensing information may be added later if the project is released publicly.

# 

# \---

# 

# \## Disclaimer

# 

# ANCHOR is an academic software project intended to support habit and addiction recovery tracking and reflection.

# 

# It is not intended to replace professional medical, psychological, addiction-treatment, crisis, or emergency services.

