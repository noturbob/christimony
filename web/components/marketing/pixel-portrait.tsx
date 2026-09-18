"use client";

import { useEffect, useRef } from "react";
import { ensureGsapRegistered, gsap } from "@/lib/gsap";

// Pixel-art couple for the hero. The source is a 64x57 PNG (the wedding photo
// cut out and crushed to 18 colours); each opaque pixel becomes a square cell
// on a canvas so it can be animated per cell:
//   - on load the cells assemble from the bottom up,
//   - on pointer-fine devices they scatter away from the cursor,
//   - as the hero scrolls away they drop out in random order into the ink.
// The bottom rows are thinned out up front so the figure dissolves into the
// page instead of ending on a hard edge.
const SRC = "/images/hero-pixels.png";

type Cell = { x: number; y: number; order: number; drop: number };

export function PixelPortrait({ className }: { className?: string }) {
  const wrapRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useEffect(() => {
    const wrap = wrapRef.current;
    const canvas = canvasRef.current;
    const ctx = canvas?.getContext("2d");
    if (!wrap || !canvas || !ctx) return;
    ensureGsapRegistered();

    const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
    const fine = window.matchMedia("(pointer: fine)").matches;

    const state = { reveal: reduced ? 1 : 0, dissolve: 0 };
    const mouse = { x: -1e4, y: -1e4, sx: -1e4, sy: -1e4 };
    let groups: { color: string; cells: Cell[] }[] = [];
    let cols = 0;
    let rows = 0;
    let size = 0;
    let dpr = 1;
    let dirty = true;
    const cleanups: (() => void)[] = [];

    function resize() {
      if (!cols) return;
      dpr = Math.min(window.devicePixelRatio || 1, 2);
      size = Math.max(2, Math.floor(Math.min(wrap!.clientWidth / cols, wrap!.clientHeight / rows)));
      canvas!.width = cols * size * dpr;
      canvas!.height = rows * size * dpr;
      canvas!.style.width = `${cols * size}px`;
      canvas!.style.height = `${rows * size}px`;
      dirty = true;
    }

    function draw() {
      ctx!.setTransform(dpr, 0, 0, dpr, 0, 0);
      ctx!.clearRect(0, 0, cols * size, rows * size);
      const gap = size > 6 ? 1 : 0.5;
      const radius = size * 7;
      for (const group of groups) {
        ctx!.fillStyle = group.color;
        for (const c of group.cells) {
          if (c.drop < state.dissolve) continue;
          // Each cell grows in over the last 20% of its slot in the sweep.
          const local = Math.min(1, (state.reveal - c.order * 0.8) / 0.2);
          if (local <= 0) continue;
          let s = (size - gap) * local;
          let px = c.x * size;
          let py = c.y * size;
          if (fine) {
            const dx = px + size / 2 - mouse.sx;
            const dy = py + size / 2 - mouse.sy;
            const d2 = dx * dx + dy * dy;
            if (d2 < radius * radius) {
              const d = Math.sqrt(d2) || 1;
              const f = 1 - d / radius;
              px += (dx / d) * f * size * 1.8;
              py += (dy / d) * f * size * 1.8;
              s *= 1 - f * 0.55;
            }
          }
          ctx!.fillRect(px + (size - s) / 2, py + (size - s) / 2, s, s);
        }
      }
    }

    function tick() {
      const mx = mouse.x - mouse.sx;
      const my = mouse.y - mouse.sy;
      if (Math.abs(mx) > 0.3 || Math.abs(my) > 0.3) {
        mouse.sx += mx * 0.16;
        mouse.sy += my * 0.16;
        dirty = true;
      }
      if (dirty) {
        dirty = false;
        draw();
      }
    }

    const img = new Image();
    img.src = SRC;
    img.onload = () => {
      cols = img.naturalWidth;
      rows = img.naturalHeight;
      const off = document.createElement("canvas");
      off.width = cols;
      off.height = rows;
      const octx = off.getContext("2d")!;
      octx.drawImage(img, 0, 0);
      const data = octx.getImageData(0, 0, cols, rows).data;

      const byColor = new Map<string, Cell[]>();
      for (let y = 0; y < rows; y++) {
        // Bottom ~30% thins out progressively into the page.
        const fade = Math.max(0, (y / rows - 0.7) / 0.3);
        for (let x = 0; x < cols; x++) {
          const i = (y * cols + x) * 4;
          if (data[i + 3] < 128 || Math.random() < fade ** 1.3) continue;
          const color = `rgb(${data[i]},${data[i + 1]},${data[i + 2]})`;
          const cell = { x, y, order: (1 - y / rows) * 0.65 + Math.random() * 0.35, drop: Math.random() };
          const list = byColor.get(color);
          if (list) list.push(cell);
          else byColor.set(color, [cell]);
        }
      }
      // Grouped by colour so each frame only switches fillStyle ~18 times.
      groups = [...byColor].map(([color, cells]) => ({ color, cells }));
      resize();

      if (reduced) {
        draw();
        return;
      }

      // Only tick while the hero is on screen.
      let ticking = false;
      const io = new IntersectionObserver(([entry]) => {
        if (entry.isIntersecting && !ticking) gsap.ticker.add(tick);
        if (!entry.isIntersecting && ticking) gsap.ticker.remove(tick);
        ticking = entry.isIntersecting;
      });
      io.observe(wrap);
      cleanups.push(() => {
        io.disconnect();
        gsap.ticker.remove(tick);
      });

      const markDirty = () => void (dirty = true);
      const intro = gsap.to(state, { reveal: 1, duration: 2, ease: "power2.out", delay: 0.3, onUpdate: markDirty });
      const section = wrap.closest("section") ?? wrap;
      const out = gsap.to(state, {
        dissolve: 1,
        ease: "none",
        onUpdate: markDirty,
        scrollTrigger: { trigger: section, start: "top top", end: "bottom 15%", scrub: true },
      });
      cleanups.push(() => {
        intro.kill();
        out.scrollTrigger?.kill();
        out.kill();
      });

      if (fine) {
        const onMove = (e: PointerEvent) => {
          const rect = canvas.getBoundingClientRect();
          mouse.x = e.clientX - rect.left;
          mouse.y = e.clientY - rect.top;
        };
        const onLeave = () => {
          mouse.x = mouse.y = -1e4;
        };
        window.addEventListener("pointermove", onMove);
        document.documentElement.addEventListener("pointerleave", onLeave);
        cleanups.push(() => {
          window.removeEventListener("pointermove", onMove);
          document.documentElement.removeEventListener("pointerleave", onLeave);
        });
      }
    };

    const ro = new ResizeObserver(resize);
    ro.observe(wrap);

    return () => {
      img.onload = null;
      ro.disconnect();
      cleanups.forEach((fn) => fn());
    };
  }, []);

  return (
    <div ref={wrapRef} aria-hidden className={className}>
      <canvas ref={canvasRef} className="block" />
    </div>
  );
}
