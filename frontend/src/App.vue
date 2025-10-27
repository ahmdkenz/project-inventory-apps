<script setup lang="ts">
import { RouterView } from 'vue-router'
import { onErrorCaptured } from 'vue'

// Handle errors globally
onErrorCaptured((err, instance, info) => {
  console.error('Error captured in App.vue:', err, info)
  return false // Prevent error from propagating
})
</script>

<template>
  <RouterView />
</template>

<style scoped></style>
