/// <reference types="vite/client" />

interface ImportMetaEnv {
  readonly VITE_FRONTEND_PROD_URL: string;
  readonly VITE_BACKEND_PROD_URL: string;
}

interface ImportMeta {
  readonly env: ImportMetaEnv;
}
