<script setup lang="ts">
import { VueFlow, useVueFlow, type Node, type Edge } from "@vue-flow/core"
import { Background } from "@vue-flow/background"
import { Controls } from "@vue-flow/controls"
import { MiniMap } from "@vue-flow/minimap"
import TeamNode from "./TeamNode.vue"
import TournamentMatchNode from "./TournamentMatchNode.vue"
import GroupNode from "./GroupNode.vue"

import "@vue-flow/core/dist/style.css"
import "@vue-flow/core/dist/theme-default.css"
import "@vue-flow/controls/dist/style.css"
import "@vue-flow/minimap/dist/style.css"

const { tournamentId } = defineProps<{
  tournamentId: string
}>()

const { data: tournamentData } = await useFetch(
  `/api/tournaments/${tournamentId}/phases`,
)

const nodes = ref<Node[]>([])
const edges = ref<Edge[]>([])

// Create nodes and edges when tournament data is available
watchEffect(() => {
  if (!tournamentData.value) return

  const data = tournamentData.value
  const nodeList: Node[] = []
  const edgeList: Edge[] = []

  // Constants for positioning
  const HORIZONTAL_SPACING = 250
  const GROUP_VERTICAL_SPACING = 300 // Increased from 250 to 400 for more spacing
  const TEAM_HEIGHT = 30
  const GROUP_PADDING = 100

  // Create group nodes with teams as children
  data.groups.forEach((group, groupIndex) => {
    // Calculate group height based on number of teams
    const groupHeight = GROUP_PADDING + group.teams.length * TEAM_HEIGHT

    // Create group parent node
    const groupNode: Node = {
      id: `group-${group.id}`,
      type: "group",
      data: { label: group.name },
      position: { x: 0, y: groupIndex * GROUP_VERTICAL_SPACING },
      style: {
        width: "200px",
        height: `${groupHeight}px`,
      },
    }
    nodeList.push(groupNode)

    // Create team nodes as children of the group node
    group.teams.forEach((team, teamIndex) => {
      const teamNode: Node = {
        id: `team-${group.id}-${team.id}`,
        type: "team",
        data: {
          label: team.name,
          teams: [team.name],
          nodeType: "team",
        },
        position: { x: 25, y: 50 + teamIndex * TEAM_HEIGHT },
        parentNode: `group-${group.id}`,
        extent: "parent",
      }
      nodeList.push(teamNode)
    })
  })

  // Create quarterfinal nodes
  data.phases.quarterFinals.forEach((match, index) => {
    const matchNode: Node = {
      id: `quarterfinal-${match.match_id}`,
      type: "tournamentMatch",
      data: {
        label: "Viertelfinale",
        teams: [match.team1_name, match.team2_name],
        winner: match.result?.winner_id
          ? match.result.winner_id === match.team1_id
            ? match.team1_name
            : match.team2_name
          : undefined,
        nodeType: "quarterfinal",
      },
      position: { x: HORIZONTAL_SPACING, y: index * GROUP_VERTICAL_SPACING },
    }
    nodeList.push(matchNode)

    // Connect group nodes to quarterfinals
    // Connect each group to the quarterfinals based on the teams in the match
    const team1GroupId = data.groups.find((group) =>
      group.teams.some((team) => team.id === match.team1_id),
    )?.id

    const team2GroupId = data.groups.find((group) =>
      group.teams.some((team) => team.id === match.team2_id),
    )?.id

    if (team1GroupId) {
      edgeList.push({
        id: `edge-group-${team1GroupId}-to-quarterfinal-${match.match_id}`,
        source: `group-${team1GroupId}`,
        target: `quarterfinal-${match.match_id}`,
        type: "smoothstep",
      })
    }

    if (team2GroupId && team2GroupId !== team1GroupId) {
      edgeList.push({
        id: `edge-group-${team2GroupId}-to-quarterfinal-${match.match_id}`,
        source: `group-${team2GroupId}`,
        target: `quarterfinal-${match.match_id}`,
        type: "smoothstep",
      })
    }
  })

  // Create semifinal nodes
  data.phases.semiFinals.forEach((match, index) => {
    const matchNode: Node = {
      id: `semifinal-${match.match_id}`,
      type: "tournamentMatch",
      data: {
        label: "Semifinale",
        teams: [match.team1_name, match.team2_name],
        winner: match.result?.winner_id
          ? match.result.winner_id === match.team1_id
            ? match.team1_name
            : match.team2_name
          : undefined,
        nodeType: "semifinal",
      },
      position: {
        x: HORIZONTAL_SPACING * 2,
        y: index * GROUP_VERTICAL_SPACING + GROUP_VERTICAL_SPACING / 2,
      },
    }
    nodeList.push(matchNode)

    // Connect quarterfinals to semifinals
    edgeList.push({
      id: `edge-to-semifinal-${index}-1`,
      source: `quarterfinal-${data.phases.quarterFinals[index * 2]?.match_id}`,
      target: `semifinal-${match.match_id}`,
      type: "smoothstep",
    })

    if (data.phases.quarterFinals[index * 2 + 1]) {
      edgeList.push({
        id: `edge-to-semifinal-${index}-2`,
        source: `quarterfinal-${data.phases.quarterFinals[index * 2 + 1].match_id}`,
        target: `semifinal-${match.match_id}`,
        type: "smoothstep",
      })
    }
  })

  // Create third place match node
  if (data.phases.thirdPlace) {
    const thirdPlaceNode: Node = {
      id: `thirdplace-${data.phases.thirdPlace.match_id}`,
      type: "tournamentMatch",
      data: {
        label: "Kleines Finale",
        teams: [
          data.phases.thirdPlace.team1_name,
          data.phases.thirdPlace.team2_name,
        ],
        winner: data.phases.thirdPlace.result?.winner_id
          ? data.phases.thirdPlace.result.winner_id ===
            data.phases.thirdPlace.team1_id
            ? data.phases.thirdPlace.team1_name
            : data.phases.thirdPlace.team2_name
          : undefined,
        nodeType: "final",
      },
      position: { x: HORIZONTAL_SPACING * 3, y: GROUP_VERTICAL_SPACING },
    }
    nodeList.push(thirdPlaceNode)

    // Connect semifinals to third place match
    data.phases.semiFinals.forEach((match, index) => {
      edgeList.push({
        id: `edge-to-thirdplace-${index}`,
        source: `semifinal-${match.match_id}`,
        target: `thirdplace-${data.phases.thirdPlace.match_id}`,
        type: "smoothstep",
        style: { strokeDasharray: "5, 5" }, // Dashed line for losers
      })
    })
  }

  // Create final match node
  if (data.phases.final) {
    const finalNode: Node = {
      id: `final-${data.phases.final.match_id}`,
      type: "tournamentMatch",
      data: {
        label: "Finale",
        teams: [data.phases.final.team1_name, data.phases.final.team2_name],
        winner: data.phases.final.result?.winner_id
          ? data.phases.final.result.winner_id === data.phases.final.team1_id
            ? data.phases.final.team1_name
            : data.phases.final.team2_name
          : undefined,
        nodeType: "final",
      },
      position: { x: HORIZONTAL_SPACING * 3, y: 0 },
    }
    nodeList.push(finalNode)

    // Connect semifinals to final
    data.phases.semiFinals.forEach((match, index) => {
      edgeList.push({
        id: `edge-to-final-${index}`,
        source: `semifinal-${match.match_id}`,
        target: `final-${data.phases.final.match_id}`,
        type: "smoothstep",
      })
    })

    // Add winner node if there is one
    if (data.winner) {
      // Find the team name for the winner
      let winnerTeamName = ""
      data.groups.forEach((group) => {
        group.teams.forEach((team) => {
          if (team.id === data.winner.team_id) {
            winnerTeamName = team.name
          }
        })
      })

      if (winnerTeamName) {
        const winnerNode: Node = {
          id: "tournament-winner",
          type: "tournamentMatch",
          data: {
            label: "Turniersieger",
            teams: [winnerTeamName],
            nodeType: "winner",
          },
          position: { x: HORIZONTAL_SPACING * 4, y: 0 },
        }
        nodeList.push(winnerNode)

        edgeList.push({
          id: "edge-to-winner",
          source: `final-${data.phases.final.match_id}`,
          target: "tournament-winner",
          type: "smoothstep",
        })
      }
    }
  }

  nodes.value = nodeList
  edges.value = edgeList
})
</script>

<template>
  <VueFlow
    v-if="tournamentData"
    v-model:nodes="nodes"
    v-model:edges="edges"
    class="bg-gray-100 dark:bg-gray-800"
    :default-viewport="{ zoom: 1.5 }"
    :min-zoom="0.2"
    :max-zoom="4"
  >
    <Background pattern-color="#aaa" :gap="16" />
    <MiniMap pannable zoomable />
    <Controls position="top-left" />

    <template #node-tournamentMatch="matchNodeProps">
      <TournamentMatchNode v-bind="matchNodeProps" />
    </template>
    <template #node-team="teamNodeProps">
      <TeamNode v-bind="teamNodeProps" />
    </template>
    <template #node-group="groupNodeProps">
      <GroupNode v-bind="groupNodeProps" />
    </template>
  </VueFlow>
  <div v-else class="flex h-full items-center justify-center">
    <p class="text-gray-500">Loading tournament data...</p>
  </div>
</template>
