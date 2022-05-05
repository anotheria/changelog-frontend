<template lang="html">
  <div>
    <template v-if="!loader">
      <div class="create">
        <button class="create__btn btn" @click="createNewItem()">
          Add item
        </button>
      </div>
      <div class="changelog">
        <template v-if="list.length">
          <div v-for="item in list" :key="item.id" class="changelog__item">
            <div class="changelog__header">
              <h2 class="changelog__title">{{ item.reason }}</h2>
              <div class="changelog__header-btns">
                <div @click="editItem(item)" class="changelog__header-btn">
                  <img src="@/style/icon/edit.svg" alt=""/>
                </div>
                <div
                  @click="showConfirmDelete(item.id)"
                  class="changelog__header-btn"
                >
                  <img src="@/style/icon/delete.svg" alt=""/>
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
                  {{ item.author[0]?.toUpperCase() || "?"}}
                </span>
                <div class="changelog__name">{{ item.author }}</div>
              </div>
              <div class="changelog__date">
                {{ this.moment(+item.timestamp).format("DD.MM.YYYY HH:mm") }}
              </div>
            </div>
          </div>
        </template>
        <template v-else>
          <div class="changelog__item">No data found</div>
        </template>
      </div>
    </template>

    <template v-else>
      <div class="loader">Loading...</div>
    </template>

    <teleport to="body" v-if="showModal">
      <ChangelogModalForm
        :filtersList="filtersList"
        :currentFormData="currentFormData"
        @closeModal="toggleModal()"
        @updateList="$emit('updateList')"
      />
    </teleport>

    <teleport to="body" v-if="isShowModalConfirm">
      <div class="modal-container">
        <div class="modal modal--center">
          <div class="modal__backdrop" @click="toggleModalConfirm(false)"></div>
          <div class="modal__content">
            <div class="modal__body">
              <div class="modal__title">Confirm</div>
              <div class="modal__text">Do you want delete this item?</div>
            </div>
            <div class="modal__footer">
              <div class="modal__footer-btns">
                <button
                  class="modal__footer-btn"
                  @click="toggleModalConfirm(false)"
                >
                  Cancel
                </button>
                <button class="modal__footer-btn" @click="deleteItem()">
                  OK
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </teleport>
  </div>
</template>

<script lang="js">
  import moment from 'moment';
  import axios from "axios";
  import ChangelogModalForm from "@/components/ChangelogModalForm";

  export default {
    name: 'changelog-list',
    components: {
      ChangelogModalForm,
    },
    props: {
      list: {
        type: Array,
        required: true
      },
      loader: {
        type: Boolean
      },
      filtersList: {
        type: Object,
        required: true
      }
    },
    emits: {
      updateList: null
    },
    mounted() {

    },

    data() {
      return {
        showModal: false,
        isShowModalConfirm: false,
        currentFormData: {},
      }
    },
    methods: {
      moment,

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
        this.toggleModal(true);
      },

      editItem(item) {
        this.currentFormData = {...item};
        this.toggleModal(true);
      },

      toggleModal(force) {
        document.body.classList.toggle('layout-fixed', force);
        this.showModal = force;
      },

      toggleModalConfirm(force) {
        document.body.classList.toggle('layout-fixed', force);
        this.isShowModalConfirm = force;
      },

      showConfirmDelete(itemId) {
        this.currentItemId = itemId;
        this.toggleModalConfirm(true);
      },

      deleteItem() {
        axios
          .delete(`api/changelog/delete/${this.currentItemId}`)
          .then(() => {
            this.$emit('updateList');
            this.toggleModalConfirm(false);
          })
          .catch((error) => console.log(error));
      }
    },
    computed: {}
  }
</script>

<style scoped lang="scss"></style>
