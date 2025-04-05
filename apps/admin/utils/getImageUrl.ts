/**
 * @description Get the public URL of an image stored in Supabase storage
 * @param filePath - The path to the image file in Supabase storage
 */
export default function (filePath: string) {
  const client = useSupabaseClient()
  const { data } = client.storage.from("images").getPublicUrl(filePath)

  return data.publicUrl
}
