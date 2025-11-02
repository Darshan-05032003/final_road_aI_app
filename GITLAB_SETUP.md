# GitLab Setup Instructions

## Current Status
✅ Git repository initialized
✅ Initial commit created (185 files)
✅ Branch: `main`

## Next Steps to Upload to GitLab

### 1. Create a GitLab Repository
1. Go to https://gitlab.com (or your GitLab instance)
2. Click "New Project" → "Create blank project"
3. Set project name: `smart_road_app` (or your preferred name)
4. Choose visibility level (Private/Internal/Public)
5. **DO NOT** check "Initialize repository with a README"
6. Click "Create project"

### 2. Add GitLab Remote and Push

**If using HTTPS:**
```bash
# Replace <your-gitlab-url> with your actual GitLab repository URL
git remote add origin https://gitlab.com/your-username/smart_road_app.git
git push -u origin main
```

**If using SSH:**
```bash
# Replace <your-gitlab-url> with your actual GitLab repository SSH URL
git remote add origin git@gitlab.com:your-username/smart_road_app.git
git push -u origin main
```

### 3. Verify
After pushing, refresh your GitLab project page. You should see all your project files.

## Troubleshooting

### If you need to authenticate:
- **HTTPS**: GitLab will prompt for username and personal access token
- **SSH**: Make sure your SSH key is added to GitLab (Settings → SSH Keys)

### To check your remote:
```bash
git remote -v
```

### To change remote URL:
```bash
git remote set-url origin <new-url>
```

## Adding Team Members to Your GitLab Project

### Step 1: Access Project Settings
1. Navigate to your GitLab project: `smart_road_app`
2. Click on **Settings** in the left sidebar (usually at the bottom)
3. Click on **Members** in the Settings submenu

### Step 2: Invite Team Members

#### Option A: Add by Username/Email (Recommended)
1. In the **Members** page, you'll see a form to "Invite members"
2. **Add people by username or email:**
   - Enter the GitLab username or email address of each team member
   - You can add multiple members at once (one per line)
3. **Select access level** (see permission levels below)
4. **Set expiration date** (optional)
5. Click **Invite members**

#### Option B: Add by Email (For Non-GitLab Users)
1. Enter their email address
2. They will receive an invitation email to join GitLab (if they don't have an account)
3. Once they create an account and accept, they'll be added to the project

### Permission Levels (Access Roles)

Choose the appropriate role for each team member:

| Role | Permission Level | Recommended For |
|------|-----------------|-----------------|
| **Guest** | 10 | View-only access, can create issues |
| **Reporter** | 20 | Can view and download code, create issues and merge requests |
| **Developer** | 30 | ✅ **Recommended for developers** - Can push to non-protected branches, create branches, merge requests |
| **Maintainer** | 40 | Full control except deleting the project |
| **Owner** | 50 | Full control including deleting project (use sparingly) |

**For your team of 3 developers:**
- **Recommended**: Give all 3 team members **Developer** (30) role
- This allows them to:
  - Clone and push code
  - Create branches
  - Create and manage merge requests
  - Push to non-protected branches

### Step 3: Protect Main Branch (Optional but Recommended)

To prevent accidental pushes to `main` branch:

1. Go to **Settings** → **Repository**
2. Scroll to **Protected branches**
3. Click **Expand** under "Protected branches"
4. Select `main` branch
5. Set **Allowed to merge**: **Developers + Maintainers**
6. Set **Allowed to push**: **Maintainers** (or **No one**)
7. Click **Protect**

This ensures:
- Team members work on feature branches
- All changes go through Merge Requests (code review)
- Only approved changes merge to `main`

### Step 4: Team Members Setup

Once invited, your team members should:

1. **Accept the invitation** (they'll receive an email)
2. **Clone the repository:**
   ```bash
   git clone https://gitlab.com/your-username/smart_road_app.git
   # or with SSH:
   git clone git@gitlab.com:your-username/smart_road_app.git
   ```
3. **Set up their development environment:**
   ```bash
   cd smart_road_app
   flutter pub get
   ```

### Quick Reference: Adding Members via GitLab UI

**Direct Path:**
```
Project → Settings → Members → Invite members
```

**URL Pattern:**
```
https://gitlab.com/your-username/smart_road_app/-/project_members
```

### Workflow for Team Collaboration

1. **Create feature branch:**
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make changes and commit:**
   ```bash
   git add .
   git commit -m "Add new feature"
   ```

3. **Push and create Merge Request:**
   ```bash
   git push origin feature/your-feature-name
   ```
   Then create a Merge Request on GitLab UI

4. **Review and merge** via GitLab Merge Request interface

## Important Notes
- ✅ Sensitive files like `local.properties` and build artifacts are excluded via `.gitignore`
- ⚠️ Firebase config files (`google-services.json`) are included. Consider removing if needed
- 📝 Your Firebase API keys in `main.dart` are visible in code. Consider using environment variables for production
- 👥 All team members will have access to the repository after accepting invitations

