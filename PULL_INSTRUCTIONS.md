# How to Pull Latest Changes from GitLab

## Quick Method: Pull with Personal Access Token

### Step 1: Create Personal Access Token (if you don't have one)
1. Go to GitLab: https://gitlab.com
2. Click your profile → **Settings** → **Access Tokens**
3. Create a new token:
   - Token name: `smart_road_app_access`
   - Expiration date: Set as needed
   - Scopes: Check `read_repository` and `write_repository`
4. Click **Create personal access token**
5. **Copy the token immediately** (you won't see it again!)

### Step 2: Pull the Latest Changes

Run this command in your terminal:

```bash
cd /home/darshan/CODING_FLUTTER/SUPERX/avinash_siddhi_code/smart_road_app
git pull origin main
```

When prompted:
- **Username**: Your GitLab username (`superx8722544`)
- **Password**: Paste your **Personal Access Token** (not your GitLab password)

---

## Alternative: Configure Git Credential Helper (One-time setup)

This saves your credentials so you don't have to enter them every time:

```bash
# Configure Git to store credentials
git config --global credential.helper store

# Then pull (enter credentials once)
git pull origin main
```

After entering credentials once, Git will remember them.

---

## Alternative: Switch to SSH (Most Secure)

If you prefer SSH over HTTPS:

1. **Generate SSH key** (if you don't have one):
   ```bash
   ssh-keygen -t ed25519 -C "your_email@example.com"
   ```

2. **Add SSH key to GitLab**:
   ```bash
   cat ~/.ssh/id_ed25519.pub
   # Copy the output
   ```
   Then: GitLab → Settings → SSH Keys → Add key

3. **Change remote URL to SSH**:
   ```bash
   git remote set-url origin git@gitlab.com:superx8722544/smart_road_app.git
   ```

4. **Pull**:
   ```bash
   git pull origin main
   ```

---

## If You Have Local Changes

If you have uncommitted changes, you have two options:

### Option A: Commit your changes first
```bash
git add .
git commit -m "My local changes"
git pull origin main
```

### Option B: Stash your changes temporarily
```bash
git stash              # Save changes temporarily
git pull origin main   # Pull teammate's changes
git stash pop          # Restore your changes
```

---

## Check What Changed

After pulling, see what your teammate changed:

```bash
# See recent commits
git log --oneline -10

# See what files changed
git log --name-only -1

# See detailed changes in last commit
git show
```

