import { NextRequest, NextResponse } from "next/server";
import { getSessionToken, clearSessionToken } from "@/lib/session";

// Backend-for-frontend proxy: the browser only ever talks to same-origin
// /api/bff/*, so the Rails JWT (in an httpOnly cookie) never needs to
// reach client JS, and the browser never needs Rails' CORS config at
// all. This also means adding an env var is the only thing that changes
// when the Rails API's real host is known.
const API_BASE_URL = process.env.API_BASE_URL || "http://localhost:3000/api/v1";

type RouteParams = { params: Promise<{ path: string[] }> };

async function forward(request: NextRequest, path: string[]) {
  const token = await getSessionToken();
  const targetUrl = `${API_BASE_URL}/${path.join("/")}${request.nextUrl.search}`;

  const headers = new Headers();
  const contentType = request.headers.get("content-type");
  if (contentType) headers.set("content-type", contentType);
  if (token) headers.set("authorization", `Bearer ${token}`);

  const hasBody = !["GET", "HEAD"].includes(request.method);

  const response = await fetch(targetUrl, {
    method: request.method,
    headers,
    body: hasBody ? request.body : undefined,
    // @ts-expect-error -- `duplex` is required by undici for streamed request bodies but isn't in the RequestInit type yet
    duplex: hasBody ? "half" : undefined,
    cache: "no-store",
  });

  if (response.status === 401) {
    await clearSessionToken();
  }

  if (response.status === 204) {
    return new NextResponse(null, { status: 204 });
  }

  const body = await response.arrayBuffer();
  return new NextResponse(body, {
    status: response.status,
    headers: { "content-type": response.headers.get("content-type") || "application/json" },
  });
}

export async function GET(request: NextRequest, ctx: RouteParams) {
  return forward(request, (await ctx.params).path);
}

export async function POST(request: NextRequest, ctx: RouteParams) {
  return forward(request, (await ctx.params).path);
}

export async function PATCH(request: NextRequest, ctx: RouteParams) {
  return forward(request, (await ctx.params).path);
}

export async function PUT(request: NextRequest, ctx: RouteParams) {
  return forward(request, (await ctx.params).path);
}

export async function DELETE(request: NextRequest, ctx: RouteParams) {
  return forward(request, (await ctx.params).path);
}
