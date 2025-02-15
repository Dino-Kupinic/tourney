<script setup lang="ts">
import type { Standing } from "~/types/standing"

defineProps<{
  standings: Standing[]
}>()
</script>

<template>
  <div
    class="flex flex-col gap-1 overflow-auto border-t border-gray-200 pb-12 pt-3 dark:border-gray-700"
  >
    <div
      class="shrink-0 overflow-hidden rounded-md border border-gray-300 dark:border-gray-700"
    >
      <table class="w-full table-auto border-separate border-spacing-0">
        <thead>
          <tr
            class="bg-gray-200 text-gray-700 dark:bg-gray-800 dark:text-gray-300"
          >
            <th class="py-2 first:rounded-tl-sm last:rounded-tr-sm">Team</th>
            <th class="py-2 first:rounded-tl-sm last:rounded-tr-sm">Punkte</th>
            <th class="px-1 py-2 first:rounded-tl-sm last:rounded-tr-sm">S</th>
            <th class="px-1 py-2 first:rounded-tl-sm last:rounded-tr-sm">N</th>
            <th class="px-1 py-2 first:rounded-tl-sm last:rounded-tr-sm">U</th>
            <th class="px-2 py-2 first:rounded-tl-sm last:rounded-tr-sm">
              Tore
            </th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="standing in standings" :key="standing.team_id!">
            <td
              class="border-r border-t border-gray-300 py-2 text-center font-medium dark:border-gray-700"
            >
              {{ standing.team_name }}
            </td>
            <td
              class="border-r border-t border-gray-300 py-2 text-center dark:border-gray-700"
            >
              {{ standing.points }}
            </td>
            <td
              class="border-r border-t border-gray-300 px-1 py-2 text-center dark:border-gray-700"
            >
              {{ standing.wins }}
            </td>
            <td
              class="border-r border-t border-gray-300 px-1 py-2 text-center dark:border-gray-700"
            >
              {{ standing.losses }}
            </td>
            <td
              class="border-r border-t border-gray-300 px-1 py-2 text-center dark:border-gray-700"
            >
              {{ standing.draws }}
            </td>
            <td
              class="flex justify-evenly border-t border-gray-300 px-2 py-2 text-center dark:border-gray-700"
            >
              <span class="text-green-500">{{ standing.goals_scored }}</span>
              <span class="text-red-500">{{ standing.goals_conceded }}</span>
              <span class="text-blue-500">{{ standing.goal_difference }}</span>
            </td>
          </tr>
        </tbody>
      </table>
    </div>
  </div>
</template>
