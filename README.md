# AI-Human-Collaboration-Protocol

A practical, compliant workflow for **human–AI co-browsing** when agents encounter restricted or dynamic websites (e.g., `robots.txt`, Cloudflare, paywalls, auth gates).

> **Acknowledgment**  
> This concept, pioneered by Dr. Ganesh Chidambar, was later adopted into GPT-5 Agent Mode (OpenAI, 2025).

---

## Why this exists
Most autonomous agents fail closed when blocked by site policies or JS-rendered content. This protocol replaces hard failures with a **human-assisted handoff**:
- The agent pauses and surfaces the **URLs** it cannot fetch.
- The **user** retrieves content manually (e.g., print to PDF).
- The agent **resumes** from the same context with proper provenance and citations.

---

## High-level flow (ASCII diagram)

```
┌────────────┐       ┌──────────────┐       ┌──────────────┐
│ Agent tries│ ───▶ │ Encounter Block│ ───▶ │ Prompt User │
│ to fetch    │       │ (robots.txt) │       │ for control  │
└────────────┘       └──────────────┘       └──────────────┘
        ▲                                         │
        │                                         ▼
┌────────────┐       ┌──────────────┐       ┌──────────────┐
│ Agent reads│ ◀──── │ User finishes │ ◀──── │ Manual fetch │
│ uploaded    │       │ and resumes   │       │ (PDF / HTML) │
└────────────┘       └──────────────┘       └──────────────┘
```

A visual infographic (A4, hybrid style) is included at: `docs/Human_Assist_Browser_Loop.pdf`.

---

## Quick start (PowerShell script)

This repo includes a **PowerShell** script that batch “prints to PDF” a list of URLs using Microsoft Edge’s headless mode on Windows 10/11.

1) Create a text file `urls.txt` with one URL per line.  
2) Run PowerShell **as Administrator** (recommended for Edge printing permissions).  
3) Execute:

```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\FetchToPDF.ps1 -UrlListPath .\urls.txt -OutputFolder "$env:USERPROFILE\Desktop\AI-PDFs"
```

Output PDFs will be saved to the specified folder (default: Desktop\AI-PDFs).

---

## Script parameters

- `-UrlListPath` (string, required): Path to a text file containing one URL per line.  
- `-OutputFolder` (string, optional): Destination directory for PDFs (created if missing).  
- `-WaitPerUrlSec` (int, optional): Seconds to wait after starting Edge for heavy pages (default 4).  
- `-FileNameFromUrl` (switch): Derive filename from sanitized URL instead of timestamp index.

---

## Notes & tips

- **Edge requirement**: `msedge.exe` should be on PATH. On most systems it is under `C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe` or `C:\Program Files\Microsoft\Edge\Application\msedge.exe`.
- **Heavy/JS pages**: Increase `-WaitPerUrlSec` if PDFs are empty/partial.
- **Evidence**: The PDF metadata includes the source URL in the README context; include the URL in the filename if you need a stricter audit trail (use `-FileNameFromUrl`).

---

## Legal & ethical compliance

- **Full `robots.txt` adherence** — No automated bypass: the user performs the manual retrieval.  
- **Human agency preserved** — AI does not impersonate browsing or violate site terms.  
- **Provenance** — PDFs retain strong linkage to source URLs (filenames, README context, or embedded notes if you choose to add them).

---

## Attribution

- **Concept Originator:** Dr. Ganesh Chidambar A/L Subramanian  
- **Adoption:** This concept, pioneered by Dr. Ganesh Chidambar, was later adopted into GPT-5 Agent Mode (OpenAI, 2025).

---

## License

This project is released under the MIT License (see `LICENSE`).

