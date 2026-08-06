# Mini Self-Check

## 1. Which 3 commands save you the most time right now, and why?

### 1. `lsblk`
It quickly shows all available disks, partitions, and mount points, making storage verification easy.

### 2. `systemctl status`
It helps me check whether a service is running and provides useful information for troubleshooting.

### 3. `journalctl -u <service-name>`
It displays service logs, helping me identify errors and diagnose issues quickly.

---

## 2. How do you check if a service is healthy?

The first commands I run are:

```bash
systemctl status nginx
```

```bash
systemctl is-active nginx
```

```bash
journalctl -u nginx -n 20
```

These commands verify whether the service is running, confirm its current state, and display recent log entries for troubleshooting.

---

## 3. How do you safely change ownership and permissions without breaking access?

Example:

```bash
sudo chown ubuntu:developers /opt/project
sudo chmod 775 /opt/project
```

This changes the ownership to the correct user and group while allowing the owner and group full access and providing read and execute permissions to others.

---

## 4. What will you focus on improving in the next 3 days?

- Gain hands-on experience with Linux Logical Volume Manager (LVM).
- Practice disk management, mounting, and filesystem operations.
- Strengthen Linux administration skills through real-world DevOps scenarios and daily command practice.