import { prisma } from "../../prisma/index.js"

export default class BaseController<T, K extends keyof T> {
  protected prismaClient = prisma
  protected model: any
  private primaryKey: K

  constructor(model: any, primaryKey: K) {
    ;((this.model = model), (this.primaryKey = primaryKey))
  }

  async findAll(): Promise<T[]> {
    return this.model.findMany()
  }
  async findById(id: T[K]): Promise<T | null> {
    return this.model.findUnique({ where: { [this.primaryKey]: id } })
  }
  async create(data: any): Promise<T | null> {
    return this.model.create({ data })
  }
  async update(id: T[K], data: any): Promise<T> {
    return this.model.update({ where: { [this.primaryKey]: id, data } })
  }
  async delete(id: T[K]) {
    return this.model.delete({ where: { [this.primaryKey]: id } })
  }
}
