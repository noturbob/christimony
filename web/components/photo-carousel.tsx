"use client";

import { useState, useRef } from "react";
import { PhotoRef } from "@/lib/profiles";

const PLACEHOLDER_URL =
  "https://www.lifewire.com/thmb/lWlCQDkZkvbWxKhkJZ6yjOJ_J4k=/1500x0/filters:no_upscale():max_bytes(150000):strip_icc()/ScreenShot2020-04-20at10.03.23AM-d55387c4422940be9a4f353182bd778c.jpg";

export function PhotoCarousel({
  photos = [],
  fallbackLetter,
}: {
  photos?: PhotoRef[];
  fallbackLetter: string;
}) {
  const [index, setIndex] = useState(0);
  const startX = useRef<number | null>(null);

  const sorted = photos.length > 0
    ? [...photos].sort((a, b) => a.position - b.position)
    : [{ id: -1, url: PLACEHOLDER_URL, position: 0 }];

  function handleTouchStart(e: React.TouchEvent) {
    startX.current = e.touches[0].clientX;
  }

  function handleTouchEnd(e: React.TouchEvent) {
    if (startX.current === null) return;
    const delta = e.changedTouches[0].clientX - startX.current;
    if (delta < -50 && index < sorted.length - 1) setIndex((i) => i + 1);
    if (delta > 50 && index > 0) setIndex((i) => i - 1);
    startX.current = null;
  }

  return (
    <div
      className="relative aspect-[4/5] bg-secondary overflow-hidden"
      onTouchStart={handleTouchStart}
      onTouchEnd={handleTouchEnd}
    >
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img src={sorted[index].url} alt="" className="w-full h-full object-cover" />

      {sorted.length > 1 && (
        <>
          <button
            onClick={() => setIndex((i) => Math.max(0, i - 1))}
            className="absolute left-0 top-0 h-full w-1/3"
            aria-label="Previous photo"
          />
          <button
            onClick={() => setIndex((i) => Math.min(sorted.length - 1, i + 1))}
            className="absolute right-0 top-0 h-full w-1/3"
            aria-label="Next photo"
          />
          <div className="absolute top-3 left-0 right-0 flex gap-1 px-3">
            {sorted.map((_, i) => (
              <div
                key={i}
                className={`h-1 flex-1 rounded-full ${i === index ? "bg-white" : "bg-white/40"}`}
              />
            ))}
          </div>
        </>
      )}
    </div>
  );
}