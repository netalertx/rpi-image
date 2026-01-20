---
name: rpi-image-build
description: Guide for building Raspberry Pi images locally using the VS Code build tasks that invoke act. Use this when you need a dev or release image and the extracted .img.xz output path.
---

# Raspberry Pi Image Builds with act

This skill helps you build Raspberry Pi images locally and locate the extracted .img.xz artifacts.

## When to use this skill

Use this skill when you need to:
- Build a development or release Raspberry Pi image from this repo
- Run the existing VS Code tasks instead of invoking act manually
- Confirm where the extracted .img.xz is written

## Running builds

1. Ensure prerequisites are available: Docker and act.
2. Run the appropriate VS Code task:
   - **Build RPi Image Locally (dev)** for a development image
   - **Build RPi Image Locally (release)** for a production image
3. Locate outputs at the repo root:
   - Dev: netalertx-rpi-image-dev/
   - Release: netalertx-rpi-image-release/

## Task behavior details

### Build RPi Image Locally (dev)
- **Purpose:** Build the development image locally.
- **Flow:**
  - Fixes ownership in /tmp and clears previous artifacts.
  - Runs act job build-dev with a privileged container.
  - Extracts the resulting .img.xz into netalertx-rpi-image-dev/ at the repo root.
- **Output location:** netalertx-rpi-image-dev/
- **Default build task:** Yes.

### Build RPi Image Locally (release)
- **Purpose:** Build the production (release) image locally.
- **Flow:**
  - Fixes ownership in /tmp and clears previous artifacts.
  - Runs act job build-release using workflow_dispatch with image_variant=production and a privileged container.
  - Extracts the resulting .img.xz into netalertx-rpi-image-release/ at the repo root.
- **Output location:** netalertx-rpi-image-release/
- **Default build task:** No.

## Best practices

- Prefer the dev build when iterating; use release only for production validation.
- Verify Docker is running before launching a build task.
- Clean up /tmp/artifacts if a previous run was interrupted.
