---
name: build-rpi-dev
description: Guide for building Raspberry Pi development images locally using the 'act' tool inside the devcontainer.
---

# Raspberry Pi Dev Image Build

This skill helps you build the Raspberry Pi development image locally by executing `act` within the running Devcontainer.

## When to use this skill

Use this skill when you need to:
- Build a fresh `netalertx-rpi-dev.img.xz` image.
- Verify the build process locally before pushing to GitHub.
- Ensure the build runs in the correct environment (Devcontainer).

## Prerequisites

- **Devcontainer running:** Ensure the container `bfc542fa0ee1` is running (`docker ps`).
- **Docker:** Must be installed and running on the host.

## Running the Build

Run the following command on the **host machine**. This sends the build instructions into the container.

```bash
docker exec -w /workspaces/rpi-image bfc542fa0ee1 bash -c "/workspaces/rpi-image/.devcontainer/scripts/build_local_dev.sh"
```

## Command Breakdown

1.  **Cleanup:** `rm -rf /tmp/artifacts` removes old artifacts to prevent permission errors.
2.  **Act Build:** `act -j build-dev ...` runs the GitHub Action job locally.
    - `--container-options "--privileged"`: Required for loop mounting.
    - `--artifact-server-path`: Stores artifacts in a temp dir.
3.  **Extraction:** `unzip` extracts the resulting zip file to the current directory.

## Artifacts

- **Output:** A `.img.xz` file will be created in the root of the repository.
- **Note:** The `act` command might report "Job failed" due to missing tokens for the Release step, but the artifact creation usually succeeds.

## Best Practices

- Always verify the container ID (`bfc542fa0ee1`) matches your actual running devcontainer.
- Do not run `act` directly on the host; it lacks the necessary tools and permissions.