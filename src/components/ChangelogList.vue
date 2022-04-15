<template lang="html">
  <div>
    <template v-if="!loader">
      <div class="changelog">
        <template v-if="list.length">
          <div v-for="item in list" :key="item.timestamp" class="changelog__item">
            <h2 class="changelog__title">{{ item.reason }}</h2>
            <div class="changelog__label">
              <div class="changelog__type">{{ item.type }}</div>
              <div v-for="tag in item.tags" :key="tag" class="changelog__tags">{{ tag }}</div>
            </div>
            <p class="changelog__text">{{ item.message }}</p>
            <div class="changelog__info">
              <div class="changelog__author">
                <span class="changelog__ava">{{ item.author[0].toUpperCase() }}</span>
                <div class="changelog__name">{{ item.author }}</div>
              </div>
              <div class="changelog__date">
                {{ this.moment(+item.timestamp).format("DD.MM.YYYY hh:mm") }}
              </div>
            </div>
          </div>
        </template>
        <template v-else>
          <div class="changelog__item">
            No data found
          </div>
        </template>
      </div>
    </template>

    <template v-else>
      <div class="loader">Loading...</div>
    </template>
  </div>
</template>

<script lang="js">
import moment from 'moment';

export default {
  name: 'changelog-list',
  props: {
    list: {
      type: Array,
      required: true
    },
    loader: {
      type: Boolean
    }
  },
  mounted() {

  },
  data() {
    return {}
  },
  methods: {
    moment: moment
  },
  computed: {}
}
</script>

<style scoped lang="scss">

</style>
