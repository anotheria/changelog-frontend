<template lang="html">

  <div class="main__col changelog">
      <div v-for="(item, index) in list" :key="index" class="changelog__item">
      <h2 class="changelog__title">{{item.title}}</h2>
      <div class="changelog__label">
        <div class="changelog__type">{{item.type}}</div>
        <div class="changelog__tags">{{item.tags}}</div>
      </div>
      <p class="changelog__text">{{item.text}}</p>
      <div class="changelog__info">
        <div class="changelog__author">
          <span class="changelog__ava">{{item.name[0].toUpperCase()}}</span>
          <div class="changelog__name">{{item.name}}</div>
        </div>
        <div class="changelog__date">{{this.moment(+item.date).format('D MMM YY')}}</div>
      </div>
    </div>
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
  .changelog-list {

  }
</style>
