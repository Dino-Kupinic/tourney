import { it, expect, describe } from "vitest"

describe("parseStringToDate", () => {
  it("should parse time string '23:59:59' correctly", () => {
    const timeString = "23:59:59"
    const date = new Date()
    date.setHours(23)
    date.setMinutes(59)
    date.setSeconds(59)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string '00:00:00' correctly", () => {
    const timeString = "00:00:00"
    const date = new Date()
    date.setHours(0)
    date.setMinutes(0)
    date.setSeconds(0)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with only hours and minutes '14:30' correctly", () => {
    const timeString = "14:30"
    const date = new Date()
    date.setHours(14)
    date.setMinutes(30)
    date.setSeconds(0)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with single-digit hours '9:45:30' correctly", () => {
    const timeString = "9:45:30"
    const date = new Date()
    date.setHours(9)
    date.setMinutes(45)
    date.setSeconds(30)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with single-digit minutes '12:5:30' correctly", () => {
    const timeString = "12:5:30"
    const date = new Date()
    date.setHours(12)
    date.setMinutes(5)
    date.setSeconds(30)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with single-digit seconds '12:30:5' correctly", () => {
    const timeString = "12:30:5"
    const date = new Date()
    date.setHours(12)
    date.setMinutes(30)
    date.setSeconds(5)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with invalid hour 'invalid:30:45' as NaN", () => {
    const timeString = "invalid:30:45"
    const date = new Date()
    date.setHours(NaN)
    date.setMinutes(30)
    date.setSeconds(45)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with invalid minute '10:invalid:45' as NaN", () => {
    const timeString = "10:invalid:45"
    const date = new Date()
    date.setHours(10)
    date.setMinutes(NaN)
    date.setSeconds(45)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with invalid second '10:30:invalid' as NaN", () => {
    const timeString = "10:30:invalid"
    const date = new Date()
    date.setHours(10)
    date.setMinutes(30)
    date.setSeconds(NaN)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse empty time string '' as NaN for all components", () => {
    const timeString = ""
    const date = new Date()
    date.setHours(NaN)
    date.setMinutes(NaN)
    date.setSeconds(NaN)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with out-of-range hours '25:30:45' as provided", () => {
    const timeString = "25:30:45"
    const date = new Date()
    date.setHours(25)
    date.setMinutes(30)
    date.setSeconds(45)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with out-of-range minutes '10:75:45' as provided", () => {
    const timeString = "10:75:45"
    const date = new Date()
    date.setHours(10)
    date.setMinutes(75)
    date.setSeconds(45)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })

  it("should parse time string with out-of-range seconds '10:30:75' as provided", () => {
    const timeString = "10:30:75"
    const date = new Date()
    date.setHours(10)
    date.setMinutes(30)
    date.setSeconds(75)
    date.setMilliseconds(0)

    expect(parseStringToDate(timeString)).toEqual(date)
  })
})
