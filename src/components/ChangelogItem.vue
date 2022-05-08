<template>
  <div>
    <div class="changelog__header">
      <h2 class="changelog__title">{{ item.reason }}</h2>
      <div class="changelog__header-btns">
        <div @click="edit(item)" class="changelog__header-btn">
          <img src="@/style/icon/edit.svg" alt="" />
        </div>
        <div @click="deleteItem(item.id)" class="changelog__header-btn">
          <img src="@/style/icon/delete.svg" alt="" />
        </div>
      </div>
    </div>
    <div class="changelog__label">
      <div class="changelog__type">{{ item.type }}</div>
      <div v-for="tag in item.tags" :key="tag" class="changelog__tags">
        {{ tag }}
      </div>
    </div>
    <p class="changelog__text">{{ item.message }}</p>
    <div class="changelog__info">
      <div class="changelog__author">
        <span class="changelog__ava">
          {{ item.author[0]?.toUpperCase() || "?" }}
        </span>
        <div class="changelog__name">{{ item.author }}</div>
      </div>
      <div class="changelog__date">
        {{ moment(+item.timestamp).format("DD.MM.YYYY HH:mm") }}
      </div>
    </div>
  </div>
</template>

<script>
import moment from 'moment';
export default {
	emits: {
		delete: null,
		edit: null
	},

	props: {
		item: {
			type: Object,
			required: true
		}
	},

	methods:{
		moment,

		deleteItem(itemId){
			this.$emit("delete", itemId);
		},

		edit(item){
			this.$emit("edit", item);
		}
	}
};
</script>

<style></style>
