export const useAppVersion = () => {
  const runtime = useRuntimeConfig()
  return runtime.public.clientVersion as string
}
