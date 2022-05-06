<template lang="html">

  <header class="header">
    <div class="container">
      <div class="header__inner">
        <div class="header__logo">Anotheria changelog</div>
        <form class="header__search search" @submit.prevent>
          <input
            @change="$emit('doSearch', inputValue)"
            class="search__input"
            type="text"
            placeholder="Search"
            v-model.trim="inputValue"
          />
          <button :type="inputValue ? 'reset' : 'submit'"
                  :class="{
                    'search__btn--close': inputValue,
                    'search__btn--search': !inputValue,
                   }"
                  @click.prevent="cleanInput"
                  class="search__btn"
          >
          </button>
        </form>
      </div>
    </div>
  </header>

</template>

<script lang="js">
  export default {
    name: 'changelog-header',
    props: {
      loader: {
        type: Boolean
      }
    },
    mounted() {

    },
    data() {
      return {
        inputValue: ''
      }
    },
    methods: {
      cleanInput() {
        this.inputValue = '';
        this.$emit('doSearch', this.inputValue)
      }
    },
    computed: {}
  }


</script>

<style scoped lang="scss">
</style>
