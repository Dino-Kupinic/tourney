export default function (timeString: string): Date {
  const [hours, minutes, seconds] = timeString.split(":").map(Number)
  const date = new Date()
  date.setHours(hours)
  date.setMinutes(minutes)
  date.setSeconds(seconds)
  return date
}
