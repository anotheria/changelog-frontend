<template>
  <div>
    <template v-if="!loader">
      <div class="create">
        <button class="create__btn btn" @click="createNewItem">
          Add item
        </button>
      </div>
      <div class="changelog">
        <template v-if="list.length">
          <ChangelogItem
            class="changelog__item"
            v-for="listItem in list"
            :key="listItem.id"
            :item="listItem"
            @delete="showConfirmDelete"
            @edit="editItem"
          />
          <VPagination
            class="changelog__pagination"
            v-model="page"
            :pages="pages"
            :range-size="1"
            @update:modelValue="$emit('changePage', page)"
          />
        </template>
        <div v-else class="changelog__item">No data found</div>
      </div>
    </template>

    <div v-else class="loader">Loading...</div>

    <ChangelogModalForm
      v-if="isShowModalForm"
      :filtersList="filtersList"
      :currentFormData="currentFormData"
      @close-modal="toggleModal('isShowModalForm', $event)"
      @add-new-tags="$emit('addNewTags', $event)"
      @update-list="$emit('updateList')"
    />

    <ChangelogModalConfirm
      v-if="isShowModalConfirm"
      @close-modal="toggleModal('isShowModalConfirm', $event)"
      @confirm="deleteItem"
    />
  </div>
</template>

<script>
import axios from "axios";
import ChangelogModalForm from "@/components/ChangelogModalForm";
import ChangelogModalConfirm from "@/components/ChangelogModalConfirm";
import ChangelogItem from "@/components/ChangelogItem";
import VPagination from "@hennge/vue3-pagination";
import "@hennge/vue3-pagination/dist/vue3-pagination.css";
import {API_URLS} from "@/constants/api-urls.constant";

export default {
  name: "changelog-list",
  components: {
    ChangelogModalForm,
    ChangelogModalConfirm,
    VPagination,
    ChangelogItem,
  },

  props: {
    list: {
      type: Array,
      required: true,
    },
    loader: {
      type: Boolean,
    },
    filtersList: {
      type: Object,
      required: true,
    },
    pages: {
      type: Number,
      required: true,
    },
    currentPage: {
      type: Number,
      required: true,
    },
  },

  emits: {
    updateList: null,
    changePage: null,
    addNewTags: null,
  },

  data: () => ({
    isShowModalForm: false,
    isShowModalConfirm: false,
    currentFormData: {},
    page: 1,
  }),

  methods: {
    createNewItem() {
      this.currentFormData = {
        id: null,
        timestamp: new Date(),
        author: "",
        message: "",
        reason: "",
        tags: [],
        type: null,
      };
      this.toggleModal( "isShowModalForm",true);
    },

    editItem(item) {
      this.currentFormData = { ...item };
      this.toggleModal("isShowModalForm", true);
    },

    toggleModal(modalType, isActive) {
      document.body.classList.toggle("layout-fixed", isActive);
      this[modalType] = isActive;
    },

    showConfirmDelete(itemId) {
      this.currentItemId = itemId;
      this.toggleModal("isShowModalConfirm", true);
    },

    deleteItem() {
      axios
        .delete(API_URLS.ROOT_URL + `api/changelog/delete/${this.currentItemId}`)
        .then(() => {
          this.$emit("updateList");
          this.toggleModal("isShowModalConfirm", false);
        })
        .catch((error) => console.log(error));
    },
  },
  computed: {},

  watch: {
    currentPage(newValue) {
      this.page = newValue;
    },
  },
};
</script>

<style scoped lang="scss"></style>
