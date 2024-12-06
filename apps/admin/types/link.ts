export type LinkGroup = Record<string, { links: Link[]; sent: boolean }>
export type Link = {
  name: string
  class: string
  url: string
}
