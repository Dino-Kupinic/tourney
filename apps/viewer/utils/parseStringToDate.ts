export default function (timeString: string): Date {
  const parts = timeString.split(":").map(Number)
  const [hours, minutes, seconds = 0] = parts
  const date = new Date()
  date.setHours(hours)
  date.setMinutes(minutes)
  date.setSeconds(seconds)
  date.setMilliseconds(0)
  return date
}
